{{strip}}
  {{set layout="main.tpl"}}
  {{use class="yii\bootstrap\ActiveForm" type="block"}}
  {{use class="yii\helpers\Url"}}
  {{use class="yii\widgets\ListView"}}
  {{$title = "{0}'s Splat Log"|translate:'app':$user->name}}
  {{set title="{{$app->name}} | {{$title}}"}}

  {{$this->registerLinkTag(['rel' => 'canonical', 'href' => $permLink])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:card', 'content' => 'summary'])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:title', 'content' => $title])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:description', 'content' => $title])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:url', 'content' => $permLink])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:site', 'content' => '@stat_ink'])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:image', 'content' => $user->userIcon->absUrl|default:$user->jdenticonPngUrl])|@void}}
  {{if $user->twitter != ''}}
    {{$this->registerMetaTag(['name' => 'twitter:creator', 'content' => '@'|cat:$user->twitter])|@void}}
  {{/if}}

  <div class="container">
    <span itemscope itemtype="http://schema.org/BreadcrumbList">
      <span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">
        <meta itemprop="url" content="{{Url::home(true)|escape}}">
        <meta itemprop="title" content="{{$app->name|escape}}">
      </span>
    </span>
    <h1>
      {{$title|escape}}
    </h1>
    
    {{$_btl = $summary->battle_count|number_format}}
    {{if $summary->wp === null}}
      {{$_wp = '-'}}
    {{else}}
      {{$_wp = $summary->wp|number_format:1|cat:'%'}}
    {{/if}}
    {{if $summary->kd_present > 0}}
      {{$_kill = ($summary->total_kill/$summary->kd_present)|number_format:2}}
      {{$_death = ($summary->total_death/$summary->kd_present)|number_format:2}}
      {{if $summary->total_death == 0}}
        {{if $summary->total_kill == 0}}
          {{$_kr = '-'}}
        {{else}}
          {{$_kr = '∞'}}
        {{/if}}
      {{else}}
        {{$_kr = ($summary->total_kill/$summary->total_death)|number_format:2}}
      {{/if}}
    {{else}}
      {{$_kill = '-'}}
      {{$_death = '-'}}
      {{$_kr = '-'}}
    {{/if}}
    {{$_formatted = 'Battles:{0} / Win %:{1} / Avg Kills:{2} / Avg Deaths:{3} / Kill Ratio:{4}'|translate:'app':[$_btl,$_wp,$_kill,$_death,$_kr]}}
    {{$_tweet = $title|cat:' [ ':$_formatted:' ]'}}
    {{$_feed = Url::to(['feed/user', 'screen_name' => $user->screen_name, 'type' => 'rss', 'lang' => $app->language], true)}}
    {{SnsWidget tweetText=$_tweet}}

    <div class="row">
      <div class="col-xs-12 col-sm-8 col-md-8 col-lg-9">
        <div class="text-right">
          {{ListView::widget([
              'dataProvider' => $battleDataProvider,
              'itemView' => 'battle.tablerow.tpl',
              'itemOptions' => [ 'tag' => false ],
              'layout' => '{pager}',
              'pager' => [
                'maxButtonCount' => 5
              ]
            ])}}
        </div>
        {{$this->render(
          '/includes/battles-summary',
          [
            'headingText' => Yii::t('app', 'Summary: Based on the current filter'),
            'summary' => $summary
          ]
        )}}
        <div>
          <a href="#filter-form" class="visible-xs-inline btn btn-info">
            <span class="fa fa-search left"></span>{{'Search'|translate:'app'|escape}}
          </a>&#32;
          <a href="#table-config" class="btn btn-default">
            <span class="fa fa-cogs left"></span>{{'View Settings'|translate:'app'|escape}}
          </a>&#32;
          {{$params = array_merge(
            $filter->toQueryParams(),
            ['v' => 'simple', '0' => 'show-v2/user', 'screen_name' => $user->screen_name]
          )}}
          <a href="{{Url::to($params)|escape}}" class="btn btn-default" rel="nofollow">
            <span class="fa fa-list left"></span>{{'Simplified List'|translate:'app'|escape}}
          </a>
        </div>

        <div class="table-responsive" id="battles">
          <table class="table table-striped table-condensed">
            <thead>
              <tr>
                <th></th>
                <th class="cell-lobby">{{'Lobby'|translate:'app'|escape}}</th>
                <th class="cell-rule">{{'Mode'|translate:'app'|escape}}</th>
                <th class="cell-rule-short">{{'Mode'|translate:'app'|escape}}</th>
                <th class="cell-map">{{'Stage'|translate:'app'|escape}}</th>
                <th class="cell-map-short">{{'Stage'|translate:'app'|escape}}</th>
                <th class="cell-main-weapon">{{'Weapon'|translate:'app'|escape}}</th>
                <th class="cell-main-weapon-short">{{'Weapon'|translate:'app'|escape}}</th>
                <th class="cell-sub-weapon">{{'Sub Weapon'|translate:'app'|escape}}</th>
                <th class="cell-special">{{'Special'|translate:'app'|escape}}</th>
                <th class="cell-level">{{'Level'|translate:'app'|escape}}</th>
                {{* <th class="cell-level-after">{{'Level (After)'|translate:'app'|escape}}</th> *}}
                <th class="cell-result">{{'Result'|translate:'app'|escape}}</th>
                <th class="cell-kd">{{'k'|translate:'app'|escape}}/{{'d'|translate:'app'|escape}}</th>
                <th class="cell-kill-ratio auto-tooltip" title="{{'Kill Ratio'|translate:'app'|escape}}">{{'Ratio'|translate:'app'|escape}}</th>
                <th class="cell-kill-rate auto-tooltip" title="{{'Kill Rate'|translate:'app'|escape}}">{{'Rate'|translate:'app'|escape}}</th>
                <th class="cell-kill-or-assist">{{'Kill or Assist'|translate:'app'|escape}}</th>
                <th class="cell-specials">{{'Specials'|translate:'app'|escape}}</th>
                <th class="cell-point">{{'Inked'|translate:'app'|escape}}</th>
                <th class="cell-rank-in-team">{{'Rank in Team'|translate:'app'|escape}}</th>
                <th class="cell-datetime">{{'Date Time'|translate:'app'|escape}}</th>
                <th class="cell-reltime">{{'Relative Time'|translate:'app'|escape}}</th>
              </tr>
            </thead>
            <tbody>
              {{ListView::widget([
                'dataProvider' => $battleDataProvider,
                'itemView' => 'battle.tablerow.tpl',
                'itemOptions' => [ 'tag' => false ],
                'layout' => '{items}'
              ])}}
            </tbody>
          </table>
        </div>
        <div class="text-right">
          {{ListView::widget([
              'dataProvider' => $battleDataProvider,
              'itemView' => 'battle.tablerow.tpl',
              'itemOptions' => [ 'tag' => false ],
              'layout' => '{pager}',
              'pager' => [
                'maxButtonCount' => 5
              ]
            ])}}
        </div>
      </div>
      <div class="col-xs-12 col-sm-4 col-md-4 col-lg-3">
        {{Battle2FilterWidget route="show-v2/user" screen_name=$user->screen_name filter=$filter}}
        {{$this->render('/includes/user-miniinfo2', ['user' => $user])}}
        {{AdWidget}}
      </div>
    </div>
    <div class="row">
      <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="table-config">
        <div>
          <label>
            <input type="checkbox" id="table-hscroll" value="1"> {{'Always enable horizontal scroll'|translate:'app'|escape}}
          <label>
        </div>
        <div class="row">
          <div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-lobby"> {{'Lobby'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-rule"> {{'Mode'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-rule-short"> {{'Mode (Short)'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-map"> {{'Stage'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-map-short"> {{'Stage (Short)'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-main-weapon"> {{'Weapon'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-main-weapon-short"> {{'Weapon (Short)'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-sub-weapon"> {{'Sub Weapon'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-special"> {{'Special'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-level"> {{'Level'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
        {{*
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-level-after"> {{'Level (After)'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
        *}}
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-result"> {{'Result'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-kd"> {{'k'|translate:'app'|escape}}/{{'d'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-kill-ratio"> {{'Kill Ratio'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-kill-rate"> {{'Kill Rate'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-kill-or-assist"> {{'Kill or Assist'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-specials"> {{'Specials'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-point"> {{'Turf Inked'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-rank-in-team"> {{'Rank in Team'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-datetime"> {{'Date Time'|translate:'app'|escape}}</label>
          </div><div class="col-xs-6 col-sm-4 col-md-4 col-lg-3">
            <label><input type="checkbox" class="table-config-chk" data-klass="cell-reltime"> {{'Relative Time'|translate:'app'|escape}}</label>
          </div>
        </div>
      </div>
    </div>
  </div>
{{/strip}}
{{registerJs}}window.battleList();{{/registerJs}}
{{registerJs}}window.battleListConfig();{{/registerJs}}
