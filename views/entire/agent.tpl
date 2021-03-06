{{strip}}
  {{set layout="main.tpl"}}

  {{$title = 'Battles and Users'|translate:'app'|cat:' - ':$name}}
  {{set title="{{$app->name}} | {{$title}}"}}

  {{$this->registerMetaTag(['name' => 'twitter:card', 'content' => 'summary'])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:title', 'content' => $title])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:description', 'content' => $title])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:site', 'content' => '@stat_ink'])|@void}}

  <div class="container">
    <h1>
      {{$title|escape}}
    </h1>

    {{AdWidget}}
    {{SnsWidget}}

    <div class="row">
      <div class="col-xs-6">
        <p>
          <a href="{{url route="entire/users"}}" class="btn btn-default">
            <span class="fa fa-angle-double-left left"></span>
            {{'Back'|translate:'app'|escape}}
          </a>
        </p>
      </div>
      {{if $combineds}}
        <div class="col-xs-6">
          <p class="text-right">
            {{foreach $combineds as $_combined}}
              {{$b32 = $_combined.name|base32_encode:false|strtolower}}
              <a href="{{url route="entire/combined-agent" b32name=$b32}}" class="btn btn-default">
                {{$_combined.name|escape}} {{'(combined)'|translate:'app'|escape}}
                &#32;<span class="fa fa-angle-double-right"></span>
              </a>
            {{/foreach}}
          </p>
        </div>
      {{/if}}
    </div>

    {{\jp3cki\yii2\flot\FlotAsset::register($this)|@void}}
    {{\jp3cki\yii2\flot\FlotTimeAsset::register($this)|@void}}
    <div id="graph" data-data="{{$posts|json_encode|escape}}" data-label-battle="{{'Battles'|translate:'app'|escape}}" data-label-user="{{'Users'|translate:'app'|escape}}">
    </div>
  </div>
{{/strip}}
{{registerCss}}
#graph{height:300px}
{{/registerCss}}
{{registerJs}}{{literal}}
(function($) {
  var $graph = $('#graph');

  function drawGraph() {
    function dateToUnixTime(d) {
      return (new Date(d + 'T00:00:00Z')).getTime();
    }
    function formatDate(date) {
      function zero(n) {
        n = n + "";
        return (n.length == 1) ? "0" + n : n;
      }
      return date.getUTCFullYear() + "-" + zero(date.getUTCMonth() + 1) + "-" + zero(date.getUTCDate());
    }

    var json = JSON.parse($graph.attr('data-data'));
    var data = [
      {
        label:$graph.attr('data-label-battle'),
        data:json.map(function(v){return[dateToUnixTime(v.date),v.battle]}),
        bars:{
          show:true,
          align: "center",
          barWidth: 86400*1000*.8,
          lineWidth:1
        },
        color:window.colorScheme.graph1
      },
      {
        label:$graph.attr('data-label-user'),
        data:json.map(function(v){return[dateToUnixTime(v.date),v.user]}),
        yaxis:2,
        color:window.colorScheme.graph2
      }
    ];
    $.plot($graph, data, {
      xaxis: {
        mode:'time',
        minTickSize:[1,'day'],
        tickFormatter: function(v) {
          return formatDate(new Date(v));
        }
      },
      yaxis: {
        min:0,
        minTickSize:1,
        tickFormatter: function(v) {
          return ~~v;
        },
      },
      y2axis: {
        min:0,
        minTickSize:1,
        tickFormatter: function(v) {
          return ~~v;
        },
        position:'right'
      },
      legend: {
        position: "nw"
      }
    });
  }

  var timerId = null;
  $(window).resize(function() {
    if (timerId !== null) {
      window.clearTimeout(timerId);
    }
    timerId = window.setTimeout(function() {
      $graph.height(
        $graph.width() * 9 /16
      );
      drawGraph();
    }, 33);
  }).resize();
})(jQuery);
{{/literal}}{{/registerJs}}
