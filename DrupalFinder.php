<?php

Class Drupal {
  public function findRoot($start_path) {
    $path = $start_path;

    # Traverse up the directory structure until we find
    # a valid drupal root, or we hit the system root.
    do {
      $valid = $this->isValidPath($path);

      if ($valid) {
        return $path;
      }

      $path = dirname($path);
    } while($path);

    return $null;
  }

  private function isValidPath($path) {
    $valid = file_exists("$path/web") && file_exists("$path/composer.json") && file_exists("$path/vendor/drush");
    return $valid;
  }

  public function findDrush($root) {
    if ($root) {
      if(file_exists("$root/vendor/drush/drush/drush")) {
        return "$root/vendor/drush/drush/drush";
      }
    }
    return null;
  }

  public function findDrupalConsole($root) {
    if ($root) {
      if(file_exists("$root/vendor/drupal/console/bin/drupal")) {
        return "$root/vendor/drupal/console/bin/drupal";
      }
    }
    return null;
  }
}