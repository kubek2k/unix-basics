#puppet essential... 
group { 'puppet': ensure => 'present' }

#global path def.
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] } 

$users = [
    "kubek2k"
]

define create_users {
    user { $name:
        ensure => "present",
        shell => "/bin/bash",
        managehome => "true",
    }

    exec { 'set password':
        command => "usermod -p '\$6\$QB2HYPCb\$Rce2CQBnF8CKLPDqLo4uycYGxqhzbOOFckM3UiXkFgvEwkR/vGaIKNFE3XJbwf9UbioNfL4pdPVunA/Y/FjNo0' ${name}",
        require => User[$name];
    }

#    file {
 #       "/home/${name}/textfiles": 
  #          ensure => "present",
   #         recurse => "true",
    #        source => "${settings::confdir}/homedir/textfiles"
    #}
}
create_users { $users: }

package { "tmux": ensure => "installed" }
package { "mc": ensure => "installed" }
package { "htop": ensure => "installed" }
package { "sl": ensure => "installed" }
