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
        managehome => true,
        password => "standardpass",
    }
}
create_users { $users: }

package { "tmux": ensure => "installed" }
package { "mc": ensure => "installed" }
package { "htop": ensure => "installed" }
package { "sl": ensure => "installed" }
