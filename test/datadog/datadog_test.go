package datadog_test

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var projectDir string = "../../datadog"

// TestIntegration : confirm resources defined in project deployed as expected
func TestIntegration(t *testing.T) {
	// ## apply/refresh terraform config
	var ddDashK8s3519_api_key, ddDashK8s3519_app_key, ddDashK8s3519_url = tfPlanApplyReadOutput(t, projectDir)
	// ## test datadog dashboard with tf output
	logDashboard(t, ddDashK8s3519_api_key, ddDashK8s3519_app_key, ddDashK8s3519_url)

	// ## test datadog integration resource
	// - get output
	// ddIntegrat_extId := terraform.OutputRequired(t, opts, "aws_integration_role_trust_policy_conditional_external_id")
	// get the external ID (tests if integration worked)
	// get `role_name`
	// get `account_name`
	// aws module - build arn from above or do a lookup for the role
	// aws module - parse the trust policy and make sure externalId matches above

	log.Println("Tests Pass")
}

func tfPlanApplyReadOutput(t *testing.T, d string) (string, string, string) {
	// ## Validate Terraform Config
	opts := &terraform.Options{
		// project directory
		TerraformDir: d, // parameterise
		// so we can follow easily as repo matures
	}
	terraform.RunTerraformCommand(t, opts, "fmt")
	terraform.InitAndApply(t, opts)

	ddDashK8s3519_id := terraform.OutputRequired(t, opts, "dashb_k8s-3519_id")
	ddDashK8s3519_api_key := terraform.OutputRequired(t, opts, "datadog_api_key")
	ddDashK8s3519_app_key := terraform.OutputRequired(t, opts, "datadog_app_key")
	ddDashK8s3519_url := fmt.Sprintf("https://api.datadoghq.com/api/v1/dashboard/%s", ddDashK8s3519_id)
	return ddDashK8s3519_api_key, ddDashK8s3519_app_key, ddDashK8s3519_url
}

func logDashboard(t *testing.T, ddDashK8s3519_api_key string, ddDashK8s3519_app_key string, ddDashK8s3519_url string) string {
	// ## test dashboard
	client, err := http.NewRequest("GET", ddDashK8s3519_url, nil)
	if err != nil {
		log.Fatalln(err)
	}
	client.Header.Set("dd-api-key", ddDashK8s3519_api_key)
	client.Header.Set("dd-application-key", ddDashK8s3519_app_key)

	getDash, err := http.DefaultClient.Do(client)
	buf := new(bytes.Buffer)
	buf.ReadFrom(getDash.Body)
	dashBody := buf.String()
	if err != nil {
		log.Fatalln(err)
	}
	if getDash.Status == "200 OK" {
		if err != nil {
			log.Fatalln(err)
		}

		log.Println("Status Code: ", string(getDash.Status))
		log.Println("Status Code: ", dashBody[:160]) // first [:160} char of string

	} else {
		log.Println("Status Code: ", string(getDash.Status))
		log.Println("Request URL: ", string(ddDashK8s3519_url))
		os.Exit(1)
	}
	defer getDash.Body.Close()
	// tried "gopkg.in/zorkian/go-datadog-api.v2" suspect old API v for `GetDashboard`
	// client := datadog.NewClient(ddDashK8s3519_api_key, ddDashK8s3519_app_key)
	// ddDash, err := client.GetDashboard(ddDashK8s3519_id) // "No dashboard matches that dash_id." as of v2.24.0
	// if err != nil {
	// 	log.Fatalf("fatal: %s\n", err)
	// }
	// log.Printf("dashboard %d: %s\n", ddDash.GetId(), ddDash.GetTitle())
	return dashBody[:160]
}
