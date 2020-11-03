resource "datadog_dashboard" "k8s-3519" {
  description  = "Our Kubernetes dashboard gives you broad visibility into the scale, status, and resource usage of your cluster and its containers. Further reading for Kubernetes monitoring:\n\n- [Autoscale Kubernetes workloads with any Datadog metric](https://www.datadoghq.com/blog/autoscale-kubernetes-datadog/)\n\n- [How to monitor Kubernetes + Docker with Datadog](https://www.datadoghq.com/blog/monitor-kubernetes-docker/)\n\n- [Monitoring in the Kubernetes era](https://www.datadoghq.com/blog/monitoring-kubernetes-era/)\n\n- [Monitoring Kubernetes performance metrics](https://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/)\n\n- [Collecting metrics with built-in Kubernetes monitoring tools](https://www.datadoghq.com/blog/how-to-collect-and-graph-kubernetes-metrics/)\n\n- [Monitoring Kubernetes with Datadog](https://www.datadoghq.com/blog/monitoring-kubernetes-with-datadog/)\n\n- [Datadog's Kubernetes integration docs](https://docs.datadoghq.com/integrations/kubernetes/)\n\nClone this template dashboard to make changes and add your own graph widgets."
  is_read_only = false
  layout_type  = "free"
  notify_list  = []
  title        = "k8s-3519"

  template_variable {
    default = "*"
    name    = "scope"
  }
  template_variable {
    default = "*"
    name    = "kube_namespace"
    prefix  = "kube_namespace"
  }
  template_variable {
    default = "*"
    name    = "kube_deployment"
    prefix  = "kube_deployment"
  }
  template_variable {
    default = "*"
    name    = "node"
    prefix  = "node"
  }
  template_variable {
    default = "*"
    name    = "label"
    prefix  = "label"
  }
  template_variable {
    default = "*"
    name    = "k8s_state_namespace"
    prefix  = "namespace"
  }
  template_variable {
    default = "*"
    name    = "k8s_state_deployment"
    prefix  = "deployment"
  }
  template_variable {
    default = "fst-platform"
    name    = "account"
    prefix  = "account_name"
  }

  widget {
    layout = {
      "height" = "14"
      "width"  = "51"
      "x"      = "143"
      "y"      = "1"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Running containers by pod"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "bars"
        q            = "sum:docker.containers.running{$scope,$node,$label,$account} by {pod_name}.fill(0)"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "24"
      "width"  = "43"
      "x"      = "151"
      "y"      = "57"
    }

    toplist_definition {
      time = {
        "live_span" = "4h"
      }
      title       = "Most memory-intensive pods"
      title_align = "left"
      title_size  = "16"

      request {
        q = "top(sum:kubernetes.memory.usage{$scope,$node,$label,$kube_namespace,$kube_deployment,!pod_name:no_pod,$account} by {pod_name}, 10, 'mean', 'desc')"

        style {
          palette = "cool"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "24"
      "width"  = "43"
      "x"      = "107"
      "y"      = "57"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Most CPU-intensive pods"
      title_align = "left"
      title_size  = "16"

      request {
        q = "top(sum:kubernetes.cpu.usage.total{$scope,$node,$label,$kube_namespace,$kube_deployment,!pod_name:no_pod,$account} by {pod_name}, 10, 'mean', 'desc')"

        style {
          palette = "warm"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "107"
      "y"      = "1"
    }

    query_value_definition {
      autoscale  = true
      precision  = 0
      text_align = "center"
      time = {
        "live_span" = "5m"
      }
      title       = "Running containers"
      title_align = "center"
      title_size  = "13"

      request {
        aggregator = "avg"
        q          = "sum:docker.containers.running{$scope,$node,$label,$account}"

        conditional_formats {
          comparator = ">"
          hide_value = false
          palette    = "green_on_white"
          value      = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "125"
      "y"      = "1"
    }

    query_value_definition {
      autoscale  = true
      precision  = 0
      text_align = "center"
      time = {
        "live_span" = "5m"
      }
      title       = "Stopped containers"
      title_align = "center"
      title_size  = "13"

      request {
        aggregator = "avg"
        q          = "sum:docker.containers.stopped{$scope,$node,$label,$account}"

        conditional_formats {
          comparator = ">"
          hide_value = false
          palette    = "yellow_on_white"
          value      = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "29"
      "x"      = "0"
      "y"      = "1"
    }

    image_definition {
      sizing = "zoom"
      url    = "/static/images/screenboard/integrations/kubernetes.jpg"
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "29"
      "x"      = "31"
      "y"      = "1"
    }

    image_definition {
      sizing = "fit"
      url    = "/static/images/screenboard/integrations/docker-logo-792x269.png"
    }
  }
  widget {
    layout = {
      "height" = "15"
      "width"  = "16"
      "x"      = "37"
      "y"      = "22"
    }

    check_status_definition {
      check    = "kubernetes.kubelet.check"
      group_by = []
      grouping = "cluster"
      tags = [
        "$scope",
        "$node",
        "$label",
        "$account",
      ]
      time = {
        "live_span" = "10m"
      }
      title       = "Kubelets up"
      title_align = "center"
      title_size  = "16"
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "50"
      "y"      = "91"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Pods Available"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "avg"
        q          = "sum:kubernetes_state.deployment.replicas_available{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account}"

        conditional_formats {
          comparator = ">"
          hide_value = false
          palette    = "green_on_white"
          value      = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "37"
      "x"      = "67"
      "y"      = "91"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Pods available"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.deployment.replicas_available{$scope,$node,$label,$k8s_state_namespace,$k8s_state_deployment,$account} by {deployment}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "green"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "50"
      "y"      = "76"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Pods desired"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "avg"
        q          = "sum:kubernetes_state.deployment.replicas_desired{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account}"

        conditional_formats {
          comparator      = ">"
          custom_fg_color = "#6a53a1"
          hide_value      = false
          palette         = "custom_text"
          value           = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "37"
      "x"      = "67"
      "y"      = "76"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Pods desired"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.deployment.replicas_desired{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account} by {deployment}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "purple"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "50"
      "y"      = "106"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Pods unavailable"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "avg"
        q          = "sum:kubernetes_state.deployment.replicas_unavailable{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account}"

        conditional_formats {
          comparator = ">"
          hide_value = false
          palette    = "yellow_on_white"
          value      = 0
        }
        conditional_formats {
          comparator = "<="
          hide_value = false
          palette    = "green_on_white"
          value      = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "37"
      "x"      = "67"
      "y"      = "106"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Pods unavailable"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.deployment.replicas_unavailable{$scope,$node,$label,$k8s_state_namespace,$k8s_state_deployment,$account} by {deployment}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "orange"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "67"
      "x"      = "37"
      "y"      = "16"
    }

    note_definition {
      background_color = "gray"
      content          = "[High level](https://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/#running-pods)"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "87"
      "x"      = "107"
      "y"      = "16"
    }

    note_definition {
      background_color = "gray"
      content          = "[Resource utilization](https://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/#toc-resource-utilization6)"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "36"
      "width"  = "36"
      "x"      = "0"
      "y"      = "35"
    }

    event_stream_definition {
      event_size = "s"
      query      = "sources:kubernetes $node  $account.value"
      time = {
        "live_span" = "1w"
      }
    }
  }
  widget {
    layout = {
      "height" = "23"
      "width"  = "50"
      "x"      = "54"
      "y"      = "22"
    }

    hostmap_definition {
      group           = []
      no_group_hosts  = true
      no_metric_hosts = false
      scope = [
        "$scope",
        "$node",
        "$label",
      ]
      title       = "Number of running pods per node"
      title_align = "left"
      title_size  = "16"

      request {
        fill {
          q = "sum:kubernetes.pods.running{$scope,$node,$label,$account} by {host}"
        }
      }

      style {
        palette      = "yellow_to_green"
        palette_flip = false
      }
    }
  }
  widget {
    layout = {
      "height" = "18"
      "width"  = "43"
      "x"      = "151"
      "y"      = "22"
    }

    hostmap_definition {
      group           = []
      no_group_hosts  = true
      no_metric_hosts = false
      scope = [
        "$scope",
        "$node",
        "$label",
        "$kube_deployment",
        "$kube_namespace",
      ]
      title       = "Memory usage per node"
      title_align = "left"
      title_size  = "16"

      request {
        fill {
          q = "sum:kubernetes.memory.usage{$scope,$node,$label,$kube_deployment,$kube_namespace,$account} by {host}"
        }
      }

      style {
        palette      = "hostmap_blues"
        palette_flip = false
      }
    }
  }
  widget {
    layout = {
      "height" = "16"
      "width"  = "43"
      "x"      = "107"
      "y"      = "121"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Network errors per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "bars"
        q            = "sum:kubernetes.network.rx_errors{$scope,$node,$label,$kube_deployment,$kube_namespace,$account} by {host}"

        style {
          palette = "warm"
        }
      }
      request {
        display_type = "bars"
        q            = "sum:kubernetes.network.tx_errors{$scope,$node,$label,$kube_deployment,$kube_namespace,$account} by {host}"

        style {
          palette = "warm"
        }
      }
      request {
        display_type = "bars"
        q            = "sum:kubernetes.network_errors{$scope,$node,$label,$kube_deployment,$kube_namespace,$account} by {host}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "warm"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "15"
      "width"  = "43"
      "x"      = "107"
      "y"      = "41"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Sum Kubernetes CPU requests per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes.cpu.requests{$scope,$node,$label,$kube_namespace,$kube_deployment,$account} by {host}"

        style {
          palette = "warm"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "15"
      "width"  = "43"
      "x"      = "151"
      "y"      = "41"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Sum Kubernetes memory requests per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes.memory.requests{$scope,$node,$label,$kube_namespace,$kube_deployment,$account} by {host}"

        style {
          palette = "cool"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "87"
      "x"      = "107"
      "y"      = "82"
    }

    note_definition {
      background_color = "gray"
      content          = "Disk I/O & Network"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "16"
      "width"  = "43"
      "x"      = "107"
      "y"      = "88"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Network in per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes.network.rx_bytes{$scope,$node,$label,$kube_namespace,$kube_deployment,$account} by {host}"

        style {
          palette = "purple"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "15"
      "width"  = "43"
      "x"      = "107"
      "y"      = "105"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Network out per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes.network.tx_bytes{$scope,$node,$label,$kube_deployment,$kube_namespace,$account} by {host}"

        style {
          palette = "green"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "36"
      "x"      = "0"
      "y"      = "16"
    }

    note_definition {
      background_color = "gray"
      content          = "[Events](https://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/#toc-correlate-with-events10)"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "9"
      "width"  = "36"
      "x"      = "0"
      "y"      = "22"
    }

    event_timeline_definition {
      query = "sources:kubernetes $node  $account.value"
      time = {
        "live_span" = "1d"
      }
      title       = "Number of Kubernetes events per node"
      title_align = "left"
      title_size  = "16"
    }
  }
  widget {
    layout = {
      "height" = "18"
      "width"  = "43"
      "x"      = "107"
      "y"      = "22"
    }

    hostmap_definition {
      group           = []
      no_group_hosts  = true
      no_metric_hosts = false
      scope = [
        "$scope",
        "$node",
        "$label",
        "$kube_deployment",
        "$kube_namespace",
      ]
      title       = "CPU utilization per node"
      title_align = "left"
      title_size  = "16"

      request {
        fill {
          q = "sum:kubernetes.cpu.usage.total{$scope,$node,$label,$kube_deployment,$kube_namespace,$account} by {host}"
        }
      }

      style {
        palette      = "YlOrRd"
        palette_flip = false
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "43"
      "x"      = "61"
      "y"      = "1"
    }

    note_definition {
      background_color = "yellow"
      content          = "This screenboard displays Kubernetes metrics. But you should also track and even prefer native container metrics.\n[Here is why](https://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/#toc-heapster-vs-native-container-metrics).\n Note that metrics are coming from [Kubernetes-state](https://github.com/kubernetes/kube-state-metrics) as well. \n If some of your graphs are empty, make sure the agents collect those as referenced [in the documentation](https://docs.datadoghq.com/integrations/kubernetes_state/). "
      font_size        = "16"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "left"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "0"
      "y"      = "76"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Desired"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "last"
        q          = "sum:kubernetes_state.daemonset.desired{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account}"

        conditional_formats {
          comparator      = ">"
          custom_fg_color = "#6a53a1"
          hide_value      = false
          palette         = "custom_text"
          value           = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "32"
      "x"      = "17"
      "y"      = "76"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Pods desired"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.daemonset.desired{$scope,$node,$label,$k8s_state_namespace,$kube_deployment,$account} by {daemonset}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "purple"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "0"
      "y"      = "91"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Ready"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "last"
        q          = "sum:kubernetes_state.daemonset.ready{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account}"

        conditional_formats {
          comparator = ">"
          hide_value = false
          palette    = "green_on_white"
          value      = 0
        }
        conditional_formats {
          comparator = "<="
          hide_value = false
          palette    = "red_on_white"
          value      = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "15"
      "width"  = "16"
      "x"      = "37"
      "y"      = "38"
    }

    check_status_definition {
      check    = "kubernetes.kubelet.check.ping"
      group_by = []
      grouping = "cluster"
      tags = [
        "$node",
        "$label",
        "$scope",
        "$account",
      ]
      time = {
        "live_span" = "10m"
      }
      title       = "Kubelet Ping"
      title_align = "center"
      title_size  = "16"
    }
  }
  widget {
    layout = {
      "height" = "23"
      "width"  = "50"
      "x"      = "54"
      "y"      = "46"
    }

    hostmap_definition {
      group           = []
      no_group_hosts  = true
      no_metric_hosts = false
      scope = [
        "$scope",
        "$node",
        "$label",
      ]
      title       = "Number of running containers per node"
      title_align = "left"
      title_size  = "16"

      request {
        fill {
          q = "sum:docker.containers.running{$scope,$node,$label,$account} by {host}"
        }
      }

      style {
        palette      = "yellow_to_green"
        palette_flip = false
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "54"
      "x"      = "50"
      "y"      = "127"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "States"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes_state.container.running{$scope,$node,$label,$k8s_state_namespace,$kube_deployment,$account}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
      request {
        display_type = "line"
        q            = "sum:kubernetes_state.container.waiting{$scope,$node,$label,$k8s_state_namespace,$kube_deployment,$account}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "warm"
        }
      }
      request {
        display_type = "line"
        q            = "sum:kubernetes_state.container.terminated{$scope,$node,$label,$k8s_state_namespace,$kube_deployment,$account}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "grey"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "32"
      "x"      = "17"
      "y"      = "112"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "1h"
      }
      title       = "Ready"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.replicaset.replicas_ready{$scope,$label,$k8s_state_namespace,$kube_deployment,$node,$account} by {replicaset}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "purple"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "32"
      "x"      = "17"
      "y"      = "127"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "1h"
      }
      title       = "Not ready"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.replicaset.replicas_desired{$scope,$label,$k8s_state_namespace,$kube_deployment,$node,$account} by {replicaset}-sum:kubernetes_state.replicaset.replicas_ready{$scope,$label,$k8s_state_namespace,$kube_deployment,$node,$account} by {replicaset}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "orange"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "15"
      "width"  = "43"
      "x"      = "151"
      "y"      = "105"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Disk reads per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes.io.read_bytes{$scope,$label,$k8s_state_namespace,$kube_deployment,$account} by {replicaset,host}-avg:kubernetes_state.replicaset.replicas_ready{$scope,$label,$k8s_state_namespace,$kube_deployment,$account} by {host}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "grey"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "16"
      "width"  = "43"
      "x"      = "151"
      "y"      = "88"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Disk writes per node"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "line"
        q            = "sum:kubernetes.io.write_bytes{$scope,$label,$k8s_state_namespace,$kube_deployment,$account} by {replicaset,host}-avg:kubernetes_state.replicaset.replicas_ready{$scope,$label,$k8s_state_namespace,$kube_deployment,$account} by {host}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "grey"
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "49"
      "x"      = "0"
      "y"      = "70"
    }

    note_definition {
      background_color = "gray"
      content          = "DaemonSets"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "54"
      "x"      = "50"
      "y"      = "70"
    }

    note_definition {
      background_color = "gray"
      content          = "Deployments"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "49"
      "x"      = "0"
      "y"      = "106"
    }

    note_definition {
      background_color = "gray"
      content          = "ReplicaSets"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "5"
      "width"  = "54"
      "x"      = "50"
      "y"      = "121"
    }

    note_definition {
      background_color = "gray"
      content          = "Containers"
      font_size        = "18"
      show_tick        = false
      text_align       = "center"
      tick_edge        = "bottom"
      tick_pos         = "50%"
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "0"
      "y"      = "112"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Ready"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "last"
        q          = "sum:kubernetes_state.replicaset.replicas_ready{$scope,$node,$label,$kube_namespace,$k8s_state_deployment,$account}"

        conditional_formats {
          comparator      = ">"
          custom_fg_color = "#6a53a1"
          hide_value      = false
          palette         = "custom_text"
          value           = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "16"
      "x"      = "0"
      "y"      = "127"
    }

    query_value_definition {
      autoscale = true
      precision = 0
      time = {
        "live_span" = "5m"
      }
      title       = "Not ready"
      title_align = "left"
      title_size  = "16"

      request {
        aggregator = "last"
        q          = "sum:kubernetes_state.replicaset.replicas_desired{$scope,$label,$k8s_state_namespace,$kube_deployment,$node,$account}-sum:kubernetes_state.replicaset.replicas_ready{$scope,$label,$k8s_state_namespace,$kube_deployment,$node,$account}"

        conditional_formats {
          comparator      = ">"
          custom_fg_color = "#6a53a1"
          hide_value      = false
          palette         = "yellow_on_white"
          value           = 0
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "14"
      "width"  = "32"
      "x"      = "17"
      "y"      = "91"
    }

    timeseries_definition {
      show_legend = false
      time = {
        "live_span" = "4h"
      }
      title       = "Pods ready"
      title_align = "left"
      title_size  = "16"

      request {
        display_type = "area"
        q            = "sum:kubernetes_state.daemonset.ready{$scope,$node,$label,$k8s_state_namespace,$kube_deployment,$account} by {daemonset}"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "green"
        }
      }
    }
  }
}