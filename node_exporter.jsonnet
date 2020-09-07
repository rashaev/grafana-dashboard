local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local row = grafana.row;
local statPanel = grafana.statPanel;
local barGaugePanel = grafana.barGaugePanel;
local prometheus = grafana.prometheus;

grafana.dashboard.new(
  'Node_Exporter',
  editable=true,
  refresh='1m',
  time_from='now-1h',
  tags=['node_exporter']
)
.addTemplate(
  grafana.template.datasource(
    name='DATASOURCE',
    query='prometheus',
    current='Victoria',
    label='DATASOURCE',
  )
)
.addTemplate(
  template.new(
    name = 'HOST',
    datasource = '$DATASOURCE',
    query = 'label_values(node_procs_running{job="node_exporter"}, instance)',
    label='HOST',
    refresh='time',
  )
)
.addTemplate(
  template.new(
    name = 'HOSTNAME',
    hide = 2,
    datasource = '$DATASOURCE',
    query = 'label_values(node_uname_info{job="node_exporter"}, nodename)',
    label='HOSTNAME',
    refresh='time',
  )
)
  .addPanel(
    row.new(
      title='Resource Details：【$HOSTNAME】'
    ), gridPos={"x": 0, "y": 0, "h": 1, "w": 24}
  )
  .addPanel(
     statPanel.new(
    'Uptime',
    justifyMode='center',
    decimals=0,
    graphMode='none',
    colorMode='value',
    unit='s',
    datasource='$DATASOURCE',
    )
    .addTarget(
    prometheus.target(
      'avg(time() - node_boot_time_seconds{instance=~\"$HOST\"})',
    )
    ), gridPos={"x": 0, "y": 0, "h": 2, "w": 2}
  )
  .addPanel(
     statPanel.new(
    'CPU Cores',
    justifyMode='center',
    decimals=0,
    graphMode='none',
    colorMode='value',
    unit='short',
    datasource='$DATASOURCE',
    )
    .addTarget(
    prometheus.target(
      'count(node_cpu_seconds_total{instance=~\"$HOST\", mode="system"})',
    )
    ), gridPos={"x": 0,"y": 3, "h": 2,"w": 2}
  )
  .addPanel(
     statPanel.new(
    'RAM Total',
    justifyMode='center',
    decimals=0,
    graphMode='none',
    colorMode='value',
    unit='bytes',
    datasource='$DATASOURCE',
    )
    .addTarget(
    prometheus.target(
      'sum(node_memory_MemTotal_bytes{instance=~"$HOST"})',
    )
    ), gridPos={"x": 0,"y": 5, "h": 2,"w": 2}
  )
.addPanel(
    barGaugePanel.new(
      unit='percent',
      title="",
      max=100,
      decimals=1,
      displayMode='lcd',
      orientation='horizontal',
      reducerFunction='last',
      thresholds=[
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
      ],
    )
    .addTargets([
      prometheus.target(
        '100 - (avg(irate(node_cpu_seconds_total{instance=~"$HOST",mode="idle"}[5m])) * 100)',
        datasource='$DATASOURCE',
        legendFormat='CPU Busy'
      ),
      prometheus.target(
        '(1 - (node_memory_MemAvailable_bytes{instance=~"$HOST"} / (node_memory_MemTotal_bytes{instance=~"$HOST"})))* 100',
        datasource='$DATASOURCE',
        legendFormat='Used RAM Memory'
      ),
      prometheus.target(
        '(node_filesystem_size_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}-node_filesystem_free_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"})*100 /(node_filesystem_avail_bytes {instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}+(node_filesystem_size_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}-node_filesystem_free_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}))',
        datasource='$DATASOURCE',
        legendFormat='Used Mount (/)'
      ),
      prometheus.target(
        '(1 - ((node_memory_SwapFree_bytes{instance=~"$HOST"} + 1)/ (node_memory_SwapTotal_bytes{instance=~"$HOST"} + 1))) * 100',
        datasource='$DATASOURCE',
        legendFormat='Used SWAP'
      )
    ]),  gridPos={"x": 2,"y": 0, "h": 6,"w": 3}
  )

  .addPanel(
    graphPanel.new(
      title='System Load',
      format='short',
      fill=0,
      min=0,
      decimals=2,
      legend_values=true,
      legend_min=true,
      legend_max=true,
      legend_current=true,
      legend_total=false,
      legend_avg=false,
      legend_rightSide=false,
      legend_alignAsTable=true,
      legend_sideWidth=250,
    )
    .addTargets([
      prometheus.target(
        'node_load1{instance="$HOST",job="node_exporter"}',
        datasource='$DATASOURCE',
        legendFormat='1m'
      ),
      prometheus.target(
        'node_load5{instance="$HOST",job="node_exporter"}',
        datasource='$DATASOURCE',
        legendFormat='5m'
      ),
      prometheus.target(
        'node_load15{instance="$HOST",job="node_exporter"}',
        datasource='$DATASOURCE',
        legendFormat='15m'
      )
    ]),  gridPos={"x": 0,"y": 9, "h": 9,"w": 8}
  )

  .addPanel(
    graphPanel.new(
      title='CPU',
      format='percent',
      fill=0,
      min=0,
      legend_values=true,
      legend_min=false,
      legend_max=false,
      legend_current=false,
      legend_total=false,
      legend_avg=false,
      legend_rightSide=false,
      legend_alignAsTable=false,
      legend_sideWidth=250,
    )
    .addTargets([
      prometheus.target(
        'avg(irate(node_cpu_seconds_total{instance=~"$HOST",mode="system"}[5m])) by (instance) *100',
        datasource='$DATASOURCE',
        legendFormat='system'
      ),
      prometheus.target(
        'avg(irate(node_cpu_seconds_total{instance=~"$HOST",mode="user"}[5m])) by (instance) *100',
        datasource='$DATASOURCE',
        legendFormat='user'
      ),
      prometheus.target(
        'avg(irate(node_cpu_seconds_total{instance=~"$HOST",mode="idle"}[5m])) by (instance) *100',
        datasource='$DATASOURCE',
        legendFormat='idle'
      ),
      prometheus.target(
        'avg(irate(node_cpu_seconds_total{instance=~"$HOST",mode="iowait"}[5m])) by (instance) *100',
        datasource='$DATASOURCE',
        legendFormat='iowait'
      )
    ]),  gridPos={"x": 8,"y": 8, "h": 9,"w": 8}
  )

  .addPanel(
    graphPanel.new(
      title='Memory',
      format='bytes',
      fill=5,
      min=0,
      legend_values=true,
      legend_min=false,
      legend_max=false,
      legend_current=false,
      legend_total=false,
      legend_avg=false,
      legend_rightSide=false,
      legend_alignAsTable=false,
      legend_sideWidth=250,
    )
  
    .addTargets([
      prometheus.target(
        'node_memory_MemTotal_bytes{instance=~"$HOST"}',
        datasource='$DATASOURCE',
        legendFormat='total'
      ),
      prometheus.target(
        'node_memory_MemTotal_bytes{instance=~"$HOST"} - node_memory_MemFree_bytes{instance=~"$HOST"} - node_memory_Buffers_bytes{instance=~"$HOST"} - node_memory_Cached_bytes{instance=~"$HOST"} - node_memory_SReclaimable_bytes{instance=~"$HOST"}',
        datasource='$DATASOURCE',
        legendFormat='used'
      ),
      prometheus.target(
        'node_memory_Shmem_bytes{instance=~"$HOST"}',
        datasource='$DATASOURCE',
        legendFormat='shared'
      ),
      prometheus.target(
        'node_memory_Buffers_bytes{instance=~"$HOST"} + node_memory_Cached_bytes{instance=~"$HOST"} + node_memory_SReclaimable_bytes{instance=~"$HOST"}',
        datasource='$DATASOURCE',
        legendFormat='buff/cache'
      ),
        prometheus.target(
        'node_memory_MemFree_bytes{instance=~"$HOST"}',
        datasource='$DATASOURCE',
        legendFormat='free'
      )
    ]),  gridPos={"x": 24,"y": 8, "h": 9,"w": 8}
  )