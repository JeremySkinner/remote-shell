<?php

function findRoot($start_path) {
  $path = $start_path;

  # Traverse up the directory structure until we find
  # a valid drupal root, or we hit the system root.
  do {
    $valid = isValidPath($path);

    if ($valid) {
      return $path;
    }

    $path = dirname($path);
  } while($path);

  return $null;
}

function isValidPath($path) {
  $valid = file_exists("$path/web") && file_exists("$path/composer.json") && file_exists("$path/vendor/drush");
  return $valid;
}

function findDrush($root) {
  if ($root) {
    if(file_exists("$root/vendor/drush/drush/drush")) {
      return "$root/vendor/drush/drush/drush";
    }
  }
  return null;
}

function findDrupalConsole($root) {
  if ($root) {
    if(file_exists("$root/vendor/drupal/console/bin/drupal")) {
      return "$root/vendor/drupal/console/bin/drupal";
    }
  }
  return null;
}

if (!isset($argv[1])) {
  echo "Unknown command. Specify 'root', 'drush' or 'drupal-console'";
  exit(1);
}

$path = getcwd();
$command = $argv[1];

if(isset($argv[2])) {
  $path = $argv[2];
}

switch($command) {
  case 'root':
    echo findRoot($path);
    break;
  case 'drush':
    echo findDrush(findRoot($path));
    break;
  case 'drupal-console':
    echo findDrupalConsole(findRoot($path)); 
    break;
}