{
  /**
   * Create a [bar gauge panel](https://grafana.com/docs/grafana/latest/panels/visualizations/bar-gauge-panel/),
   *
   * @name barGaugePanel.new
   *
   * @param title Panel title.
   * @param description (optional) Panel description.
   * @param datasource (optional) Panel datasource.
   * @param unit (optional) The unit of the data.
   * @param thresholds (optional) An array of threashold values.
   * @param allValues (default `false`) Show all values instead of reducing to one.
   * @param valueLimit (optional) Limit of values in all values mode.
   * @param reducerFunction (default `'mean'`) Function to use to reduce values to when using single value.
   * @param fields (default `''`) Fields that should be included in the panel.
   * @param min (optional) Leave empty to calculate based on all values.
   * @param max (optional) Leave empty to calculate based on all values.
   * @param decimals Number of decimal places to show.
   * @param noValue (optional) What to show when there is no value.
   * @param thresholdsMode (default `'absolute'`) 'absolute' or 'percentage'.
   
   * @method addTarget(target) Adds a target object.
   * @method addTargets(targets) Adds an array of targets.
   */
  new(
    title,
    description=null,
    datasource=null,
    unit=null,
    thresholds=[],
    allValues=false,
    valueLimit=null,
    min=null,
    max=null,
    reducerFunction='last',
    orientation='auto',
    displayMode='lcd',
    decimals=null,
    thresholdsMode='absolute',
    fields='',
    noValue=null,
  ):: {
    type: 'bargauge',
    title: title,
    [if description != null then 'description']: description,
    datasource: datasource,
    targets: [
    ],
    options: {
        reduceOptions: {
          values: allValues,
          [if allValues && valueLimit != null then 'limit']: valueLimit,
          calcs: [
            reducerFunction,
          ],
          fields: fields,
        },
        orientation: orientation,
        displayMode: displayMode,
      },
    fieldConfig: {
      defaults: {
        unit: unit,
        [if min != null then 'min']: min,
        [if max != null then 'max']: max,
        [if decimals != null then 'decimals']: decimals,
        [if noValue != null then 'noValue']: noValue,
        thresholds: {
          mode: thresholdsMode,
          steps: thresholds,
        },
          mappings: [],
          links: [],
      },
    },
      // thresholds
      addThreshold(step):: self {
        fieldConfig+: { defaults+: { thresholds+: { steps+: [step] } } },
      },

      // mappings
      _nextMapping:: 0,
      addMapping(mapping):: self {
        local nextMapping = super._nextMapping,
        _nextMapping: nextMapping + 1,
        fieldConfig+: { defaults+: { mappings+: [mapping { id: nextMapping }] } },
      },

      // data links
      addDataLink(link):: self {
        fieldConfig+: { defaults+: { links+: [link] } },
      },

    _nextTarget:: 0,
    addTarget(target):: self {
      // automatically ref id in added targets.
      local nextTarget = super._nextTarget,
      _nextTarget: nextTarget + 1,
      targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
    },
    addTargets(targets):: std.foldl(function(p, t) p.addTarget(t), targets, self),
  },
}
