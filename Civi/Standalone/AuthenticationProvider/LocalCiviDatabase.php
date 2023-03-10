<?php
namespace Civi\Standalone\AuthenticationProvider;

class LocalCiviDatabase implements AuthenticationProviderInterface {

  /**
   * @var \Civi\Standalone\AuthenticationProvider\LocalCiviDatabase
   */
  private static $_singleton;

  public static function singleton(): LocalCiviDatabase {
    if (!isset(self::$_singleton)) {
      self::$_singleton = new static();
    }
    return self::$_singleton;
  }

  /**
   * Authenticate the user using the password in the local civi database
   * @param string $username
   * @param string $password
   * @return int
   */
  public function authenticate(string $username, string $password): int {
    $uid = 0;
    $user = new \CRM_Standaloneusers_DAO_User();
    $user->username = $username;
    if ($user->find(TRUE)) {
      // @todo obviously these wouldn't be stored in plain text
      if ($password === $user->password) {
        $uid = $user->id;

        $ufmatch = new \CRM_Core_DAO_UFMatch();
        $ufmatch->uf_id = $uid;
        if ($ufmatch->find(TRUE)) {
          \CRM_Core_Session::singleton()->set('userID', $ufmatch->contact_id);
        }
      }
    }
    return $uid;
  }

}
