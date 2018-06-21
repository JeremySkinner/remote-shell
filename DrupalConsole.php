<?php
require 'DrupalFinder.php';

$args = $argv;
array_shift($args);

$path = getcwd();
$drupal = new Drupal();
$root = $drupal->findRoot($path);
$console = $drupal->findDrupalConsole($root);

if ($console) {
  $a = implode(" ", $args);
  # Make sure we run in the web directory
  chdir("$root/web");
  echo shell_exec("php $console $a");
  chdir($path);
}
else {
  print "Could not find drupal console.";
  exit(1);
}