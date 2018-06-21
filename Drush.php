<?php
require 'DrupalFinder.php';

$args = $argv;
array_shift($args);

$path = getcwd();
$drupal = new Drupal();
$root = $drupal->findRoot($path);
$drush = $drupal->findDrush($root);

if ($drush) {
  $a = implode(" ", $args);
  # Make sure we run drush in the web directory
  chdir("$root/web");
  echo shell_exec("php $drush $a");
  chdir($path);
}
else {
  print "Could not find drush.";
  exit(1);
}