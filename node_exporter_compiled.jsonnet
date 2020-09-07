{
   "__inputs": [ ],
   "__requires": [ ],
   "annotations": {
      "list": [ ]
   },
   "editable": true,
   "gnetId": null,
   "graphTooltip": 0,
   "hideControls": false,
   "id": null,
   "links": [ ],
   "panels": [
      {
         "collapse": false,
         "collapsed": false,
         "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 0
         },
         "id": 2,
         "panels": [ ],
         "repeat": null,
         "repeatIteration": null,
         "repeatRowId": null,
         "showTitle": true,
         "title": "Resource Details：【$HOSTNAME】",
         "titleSize": "h6",
         "type": "row"
      },
      {
         "datasource": "$DATASOURCE",
         "fieldConfig": {
            "defaults": {
               "decimals": 0,
               "links": [ ],
               "mappings": [ ],
               "thresholds": {
                  "mode": "absolute",
                  "steps": [ ]
               },
               "unit": "s"
            }
         },
         "gridPos": {
            "h": 2,
            "w": 2,
            "x": 0,
            "y": 0
         },
         "id": 3,
         "links": [ ],
         "options": {
            "colorMode": "value",
            "graphMode": "none",
            "justifyMode": "center",
            "orientation": "auto",
            "reduceOptions": {
               "calcs": [
                  "mean"
               ],
               "fields": "",
               "values": false
            }
         },
         "pluginVersion": "7",
         "targets": [
            {
               "expr": "avg(time() - node_boot_time_seconds{instance=~\"$HOST\"})",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "",
               "refId": "A"
            }
         ],
         "title": "Uptime",
         "transparent": false,
         "type": "stat"
      },
      {
         "datasource": "$DATASOURCE",
         "fieldConfig": {
            "defaults": {
               "decimals": 0,
               "links": [ ],
               "mappings": [ ],
               "thresholds": {
                  "mode": "absolute",
                  "steps": [ ]
               },
               "unit": "short"
            }
         },
         "gridPos": {
            "h": 2,
            "w": 2,
            "x": 0,
            "y": 3
         },
         "id": 4,
         "links": [ ],
         "options": {
            "colorMode": "value",
            "graphMode": "none",
            "justifyMode": "center",
            "orientation": "auto",
            "reduceOptions": {
               "calcs": [
                  "mean"
               ],
               "fields": "",
               "values": false
            }
         },
         "pluginVersion": "7",
         "targets": [
            {
               "expr": "count(node_cpu_seconds_total{instance=~\"$HOST\", mode=\"system\"})",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "",
               "refId": "A"
            }
         ],
         "title": "CPU Cores",
         "transparent": false,
         "type": "stat"
      },
      {
         "datasource": "$DATASOURCE",
         "fieldConfig": {
            "defaults": {
               "decimals": 0,
               "links": [ ],
               "mappings": [ ],
               "thresholds": {
                  "mode": "absolute",
                  "steps": [ ]
               },
               "unit": "bytes"
            }
         },
         "gridPos": {
            "h": 2,
            "w": 2,
            "x": 0,
            "y": 5
         },
         "id": 5,
         "links": [ ],
         "options": {
            "colorMode": "value",
            "graphMode": "none",
            "justifyMode": "center",
            "orientation": "auto",
            "reduceOptions": {
               "calcs": [
                  "mean"
               ],
               "fields": "",
               "values": false
            }
         },
         "pluginVersion": "7",
         "targets": [
            {
               "expr": "sum(node_memory_MemTotal_bytes{instance=~\"$HOST\"})",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "",
               "refId": "A"
            }
         ],
         "title": "RAM Total",
         "transparent": false,
         "type": "stat"
      },
      {
         "datasource": null,
         "fieldConfig": {
            "defaults": {
               "decimals": 1,
               "links": [ ],
               "mappings": [ ],
               "max": 100,
               "thresholds": {
                  "mode": "absolute",
                  "steps": [
                     {
                        "color": "green",
                        "value": null
                     },
                     {
                        "color": "yellow",
                        "value": 80
                     },
                     {
                        "color": "red",
                        "value": 90
                     }
                  ]
               },
               "unit": "percent"
            }
         },
         "gridPos": {
            "h": 6,
            "w": 3,
            "x": 2,
            "y": 0
         },
         "id": 6,
         "options": {
            "displayMode": "lcd",
            "orientation": "horizontal",
            "reduceOptions": {
               "calcs": [
                  "last"
               ],
               "fields": "",
               "values": false
            }
         },
         "targets": [
            {
               "datasource": "$DATASOURCE",
               "expr": "100 - (avg(irate(node_cpu_seconds_total{instance=~\"$HOST\",mode=\"idle\"}[5m])) * 100)",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "CPU Busy",
               "refId": "A"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "(1 - (node_memory_MemAvailable_bytes{instance=~\"$HOST\"} / (node_memory_MemTotal_bytes{instance=~\"$HOST\"})))* 100",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "Used RAM Memory",
               "refId": "B"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "(node_filesystem_size_bytes{instance=~\"$HOST\",fstype=~\"ext.*|xfs\",mountpoint=\"/\"}-node_filesystem_free_bytes{instance=~\"$HOST\",fstype=~\"ext.*|xfs\",mountpoint=\"/\"})*100 /(node_filesystem_avail_bytes {instance=~\"$HOST\",fstype=~\"ext.*|xfs\",mountpoint=\"/\"}+(node_filesystem_size_bytes{instance=~\"$HOST\",fstype=~\"ext.*|xfs\",mountpoint=\"/\"}-node_filesystem_free_bytes{instance=~\"$HOST\",fstype=~\"ext.*|xfs\",mountpoint=\"/\"}))",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "Used Mount (/)",
               "refId": "C"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "(1 - ((node_memory_SwapFree_bytes{instance=~\"$HOST\"} + 1)/ (node_memory_SwapTotal_bytes{instance=~\"$HOST\"} + 1))) * 100",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "Used SWAP",
               "refId": "D"
            }
         ],
         "title": "",
         "type": "bargauge"
      },
      {
         "aliasColors": { },
         "bars": false,
         "dashLength": 10,
         "dashes": false,
         "datasource": null,
         "decimals": 2,
         "fill": 0,
         "gridPos": {
            "h": 9,
            "w": 8,
            "x": 0,
            "y": 9
         },
         "id": 7,
         "legend": {
            "alignAsTable": true,
            "avg": false,
            "current": true,
            "max": true,
            "min": true,
            "rightSide": false,
            "show": true,
            "sideWidth": 250,
            "total": false,
            "values": true
         },
         "lines": true,
         "linewidth": 1,
         "links": [ ],
         "nullPointMode": "null",
         "percentage": false,
         "pointradius": 5,
         "points": false,
         "renderer": "flot",
         "repeat": null,
         "seriesOverrides": [ ],
         "spaceLength": 10,
         "stack": false,
         "steppedLine": false,
         "targets": [
            {
               "datasource": "$DATASOURCE",
               "expr": "node_load1{instance=\"$HOST\",job=\"node_exporter\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "1m",
               "refId": "A"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "node_load5{instance=\"$HOST\",job=\"node_exporter\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "5m",
               "refId": "B"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "node_load15{instance=\"$HOST\",job=\"node_exporter\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "15m",
               "refId": "C"
            }
         ],
         "thresholds": [ ],
         "timeFrom": null,
         "timeShift": null,
         "title": "System Load",
         "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
         },
         "type": "graph",
         "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": [ ]
         },
         "yaxes": [
            {
               "decimals": 2,
               "format": "short",
               "label": null,
               "logBase": 1,
               "max": null,
               "min": 0,
               "show": true
            },
            {
               "decimals": 2,
               "format": "short",
               "label": null,
               "logBase": 1,
               "max": null,
               "min": 0,
               "show": true
            }
         ]
      },
      {
         "aliasColors": { },
         "bars": false,
         "dashLength": 10,
         "dashes": false,
         "datasource": null,
         "fill": 0,
         "gridPos": {
            "h": 9,
            "w": 8,
            "x": 8,
            "y": 8
         },
         "id": 8,
         "legend": {
            "alignAsTable": false,
            "avg": false,
            "current": false,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sideWidth": 250,
            "total": false,
            "values": true
         },
         "lines": true,
         "linewidth": 1,
         "links": [ ],
         "nullPointMode": "null",
         "percentage": false,
         "pointradius": 5,
         "points": false,
         "renderer": "flot",
         "repeat": null,
         "seriesOverrides": [ ],
         "spaceLength": 10,
         "stack": false,
         "steppedLine": false,
         "targets": [
            {
               "datasource": "$DATASOURCE",
               "expr": "avg(irate(node_cpu_seconds_total{instance=~\"$HOST\",mode=\"system\"}[5m])) by (instance) *100",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "system",
               "refId": "A"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "avg(irate(node_cpu_seconds_total{instance=~\"$HOST\",mode=\"user\"}[5m])) by (instance) *100",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "user",
               "refId": "B"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "avg(irate(node_cpu_seconds_total{instance=~\"$HOST\",mode=\"idle\"}[5m])) by (instance) *100",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "idle",
               "refId": "C"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "avg(irate(node_cpu_seconds_total{instance=~\"$HOST\",mode=\"iowait\"}[5m])) by (instance) *100",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "iowait",
               "refId": "D"
            }
         ],
         "thresholds": [ ],
         "timeFrom": null,
         "timeShift": null,
         "title": "CPU",
         "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
         },
         "type": "graph",
         "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": [ ]
         },
         "yaxes": [
            {
               "format": "percent",
               "label": null,
               "logBase": 1,
               "max": null,
               "min": 0,
               "show": true
            },
            {
               "format": "percent",
               "label": null,
               "logBase": 1,
               "max": null,
               "min": 0,
               "show": true
            }
         ]
      },
      {
         "aliasColors": { },
         "bars": false,
         "dashLength": 10,
         "dashes": false,
         "datasource": null,
         "fill": 5,
         "gridPos": {
            "h": 9,
            "w": 8,
            "x": 24,
            "y": 8
         },
         "id": 9,
         "legend": {
            "alignAsTable": false,
            "avg": false,
            "current": false,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sideWidth": 250,
            "total": false,
            "values": true
         },
         "lines": true,
         "linewidth": 1,
         "links": [ ],
         "nullPointMode": "null",
         "percentage": false,
         "pointradius": 5,
         "points": false,
         "renderer": "flot",
         "repeat": null,
         "seriesOverrides": [ ],
         "spaceLength": 10,
         "stack": false,
         "steppedLine": false,
         "targets": [
            {
               "datasource": "$DATASOURCE",
               "expr": "node_memory_MemTotal_bytes{instance=~\"$HOST\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "total",
               "refId": "A"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "node_memory_MemTotal_bytes{instance=~\"$HOST\"} - node_memory_MemFree_bytes{instance=~\"$HOST\"} - node_memory_Buffers_bytes{instance=~\"$HOST\"} - node_memory_Cached_bytes{instance=~\"$HOST\"} - node_memory_SReclaimable_bytes{instance=~\"$HOST\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "used",
               "refId": "B"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "node_memory_Shmem_bytes{instance=~\"$HOST\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "shared",
               "refId": "C"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "node_memory_Buffers_bytes{instance=~\"$HOST\"} + node_memory_Cached_bytes{instance=~\"$HOST\"} + node_memory_SReclaimable_bytes{instance=~\"$HOST\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "buff/cache",
               "refId": "D"
            },
            {
               "datasource": "$DATASOURCE",
               "expr": "node_memory_MemFree_bytes{instance=~\"$HOST\"}",
               "format": "time_series",
               "intervalFactor": 2,
               "legendFormat": "free",
               "refId": "E"
            }
         ],
         "thresholds": [ ],
         "timeFrom": null,
         "timeShift": null,
         "title": "Memory",
         "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
         },
         "type": "graph",
         "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": [ ]
         },
         "yaxes": [
            {
               "format": "bytes",
               "label": null,
               "logBase": 1,
               "max": null,
               "min": 0,
               "show": true
            },
            {
               "format": "bytes",
               "label": null,
               "logBase": 1,
               "max": null,
               "min": 0,
               "show": true
            }
         ]
      }
   ],
   "refresh": "1m",
   "rows": [ ],
   "schemaVersion": 14,
   "style": "dark",
   "tags": [
      "node_exporter"
   ],
   "templating": {
      "list": [
         {
            "current": {
               "text": "Victoria",
               "value": "Victoria"
            },
            "hide": 0,
            "label": "DATASOURCE",
            "name": "DATASOURCE",
            "options": [ ],
            "query": "prometheus",
            "refresh": 1,
            "regex": "",
            "type": "datasource"
         },
         {
            "allValue": null,
            "current": { },
            "datasource": "$DATASOURCE",
            "hide": 0,
            "includeAll": false,
            "label": "HOST",
            "multi": false,
            "name": "HOST",
            "options": [ ],
            "query": "label_values(node_procs_running{job=\"node_exporter\"}, instance)",
            "refresh": 2,
            "regex": "",
            "sort": 0,
            "tagValuesQuery": "",
            "tags": [ ],
            "tagsQuery": "",
            "type": "query",
            "useTags": false
         },
         {
            "allValue": null,
            "current": { },
            "datasource": "$DATASOURCE",
            "hide": 2,
            "includeAll": false,
            "label": "HOSTNAME",
            "multi": false,
            "name": "HOSTNAME",
            "options": [ ],
            "query": "label_values(node_uname_info{job=\"node_exporter\"}, nodename)",
            "refresh": 2,
            "regex": "",
            "sort": 0,
            "tagValuesQuery": "",
            "tags": [ ],
            "tagsQuery": "",
            "type": "query",
            "useTags": false
         }
      ]
   },
   "time": {
      "from": "now-1h",
      "to": "now"
   },
   "timepicker": {
      "refresh_intervals": [
         "5s",
         "10s",
         "30s",
         "1m",
         "5m",
         "15m",
         "30m",
         "1h",
         "2h",
         "1d"
      ],
      "time_options": [
         "5m",
         "15m",
         "1h",
         "6h",
         "12h",
         "24h",
         "2d",
         "7d",
         "30d"
      ]
   },
   "timezone": "browser",
   "title": "Node_Exporter",
   "version": 0
}
