local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
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
      unit='percent (0-100)',
      title=""
    )
    .addTarget(
      prometheus.target(
        '100 - (avg(irate(node_cpu_seconds_total{instance=~"$HOST",mode="idle"}[5m])) * 100)',
        datasource='$DATASOURCE',
        legendFormat='CPU Busy'
      )
    )
    .addTarget(
      prometheus.target(
        '(1 - (node_memory_MemAvailable_bytes{instance=~"$HOST"} / (node_memory_MemTotal_bytes{instance=~"$HOST"})))* 100',
        datasource='$DATASOURCE',
        legendFormat='Used RAM Memory'
      )
    )
    .addTarget(
      prometheus.target(
        '(node_filesystem_size_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}-node_filesystem_free_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"})*100 /(node_filesystem_avail_bytes {instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}+(node_filesystem_size_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}-node_filesystem_free_bytes{instance=~"$HOST",fstype=~"ext.*|xfs",mountpoint="/"}))',
        datasource='$DATASOURCE',
        legendFormat='Used Mount (/)'
      )
    )
    .addTarget(
      prometheus.target(
        '(1 - ((node_memory_SwapFree_bytes{instance=~"$HOST"} + 1)/ (node_memory_SwapTotal_bytes{instance=~"$HOST"} + 1))) * 100',
        datasource='$DATASOURCE',
        legendFormat='Used SWAP'
      )
    ),  gridPos={"x": 2,"y": 0, "h": 6,"w": 3}
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
      legend_rightSide=true,
      legend_alignAsTable=true,
      legend_sideWidth=250,
    )
    .addTarget(
      prometheus.target(
        'node_load1{instance="$HOST",job="node_exporter"}',
        datasource='$DATASOURCE',
        legendFormat='1m'
      )
    )
    .addTarget(
      prometheus.target(
        'node_load5{instance="$HOST",job="node_exporter"}',
        datasource='$DATASOURCE',
        legendFormat='5m'
      )
    )
    .addTarget(
      prometheus.target(
        'node_load15{instance="$HOST",job="node_exporter"}',
        datasource='$DATASOURCE',
        legendFormat='15m'
      )
    ),  gridPos={"x": 0,"y": 7, "h": 6,"w": 10}
  )