<?php
use app\assets\SortableTableAsset;
use app\components\widgets\AdWidget;
use app\components\widgets\SnsWidget;
use yii\bootstrap\Html;

$this->context->layout = 'main.tpl';
$this->title = Yii::t('app', 'API Info: Weapons (Splatoon 2)');

$this->registerMetaTag(['name' => 'twitter:card', 'content' => 'summary']);
$this->registerMetaTag(['name' => 'twitter:title', 'content' => $this->title]);
$this->registerMetaTag(['name' => 'twitter:description', 'content' => $this->title]);
$this->registerMetaTag(['name' => 'twitter:site', 'content' => '@stat_ink']);

SortableTableAsset::register($this);
?>
<div class="container">
  <h1>
    <?= Html::encode($this->title) . "\n" ?>
  </h1>
  <?= AdWidget::widget() . "\n" ?>
  <?= SnsWidget::widget() . "\n" ?>
  <p>
    <?= Html::a(
      implode('', [
        Html::tag('span', '', ['class' => ['fa fa-file-code-o fa-fw']]),
        Html::encode(Yii::t('app', 'JSON format')),
      ]),
      ['api-v2/weapon'],
      ['class' => 'label label-default']
    ) ."\n" ?>
    <?= Html::a(
      implode('', [
        Html::tag('span', '', ['class' => ['fa fa-file-excel-o fa-fw']]),
        Html::encode(Yii::t('app', 'CSV format')),
      ]),
      ['api-v2/weapon', 'format' => 'csv'],
      ['class' => 'label label-default']
    ) ."\n" ?>
  </p>
  <div class="table-responsive table-responsive-force">
    <table class="table table-striped table-condensed table-sortable">
      <thead>
        <tr>
          <th data-sort="int">
            <?= Html::encode(Yii::t('app', 'Category') . ' 1') . "\n" ?>
          </th>
          <th data-sort="int">
            <?= Html::encode(Yii::t('app', 'Category') . ' 2') . "\n" ?>
          </th>
          <th data-sort="string">
            <code>key</code>
          </th>
<?php foreach ($langs as $i => $lang): ?>
          <th data-sort="string">
            <?= Html::encode($lang['name']) . "\n" ?>
          </th>
<?php if ($i === 0): ?>
          <th data-sort="string">
            <?= Html::encode(Yii::t('app', 'Sub Weapon')) . "\n" ?>
          </th>
          <th data-sort="string">
            <?= Html::encode(Yii::t('app', 'Special')) . "\n" ?>
          </th>
          <th data-sort="string">
            <?= Html::encode(Yii::t('app', 'Main Weapon')) . "\n" ?>
          </th>
          <th data-sort="string">
            <?= Html::encode(Yii::t('app', 'Reskin of')) . "\n" ?>
          </th>
<?php endif; ?>
<?php endforeach; ?>
        </tr>
      </thead>
      <tbody>
<?php $i = 0; ?>
<?php foreach ($categories as $category): ?>
<?php foreach ($category['types'] as $type): ?>
<?php foreach ($type['weapons'] as $weapon): ?>
<?php ++$i; ?>
        <tr>  
          <td data-sort-value="<?= Html::encode((string)$i) ?>">
            <?= Html::encode($category['name']) . "\n" ?>
          </td>
          <td data-sort-value="<?= Html::encode((string)$i) ?>">
            <?= Html::encode($type['name']) . "\n" ?>
          </td>
          <td data-sort-value="<?= Html::encode($weapon['key']) ?>">
            <code><?= Html::encode($weapon['key']) ?></code>
          </td>
<?php foreach ($langs as $j => $lang): ?>
          <td>
            <?= Html::encode(
                $weapon['names'][str_replace('-', '_', $lang['lang'])]
              ) . "\n"
            ?>
          </td>
<?php if ($j === 0): ?>
          <td>
            <?= Html::encode($weapon['sub']) . "\n" ?>
          </td>
          <td>
            <?= Html::encode($weapon['special']) . "\n" ?>
          </td>
          <td data-sort-value="<?= Html::encode($weapon['mainReference']) ?>">
            <?= Html::encode($weapon['mainReference']) . "\n" ?>
          </td>
          <td data-sort-value="<?= Html::encode($weapon['canonical']) ?>">
            <?= Html::encode($weapon['canonical']) . "\n" ?>
          </td>
<?php endif ?>
<?php endforeach ?>
        </tr>
<?php endforeach; endforeach; endforeach; ?>
      </tbody>
    </table>
  </div>
  <hr>
  <p>
    <img src="/static-assets/cc/cc-by.svg" alt="CC-BY 4.0"><br>
    <?= Yii::t('app', 'This document is under a <a href="http://creativecommons.org/licenses/by/4.0/deed.en">Creative Commons Attribution 4.0 International License</a>.') . "\n" ?>
  </p>
</div>
