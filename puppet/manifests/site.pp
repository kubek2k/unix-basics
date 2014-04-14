#puppet essential... 
group { 'puppet': ensure => 'present' }

#global path def.
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] } 

$users = [
    "yuriy",
    "mariusz",
    "pawel",
    "maciej",
    "wojciech",
    "adam",
    "macpro",
    "artur",
    "katarzyna",
    "andrzej",
    "kubek2k",
]

define create_users {
    user { $name:
        ensure => "present",
        shell => "/bin/bash",
        managehome => "true",
    }

    exec { "set password for ${name}":
        command => "usermod -p '\$6\$QB2HYPCb\$Rce2CQBnF8CKLPDqLo4uycYGxqhzbOOFckM3UiXkFgvEwkR/vGaIKNFE3XJbwf9UbioNfL4pdPVunA/Y/FjNo0' ${name}",
        require => User[$name];
    }

    file {
        "/home/${name}/documents": 
            ensure => "present",
            recurse => "true",
            source => "/vagrant/homedir/documents",
            require => User[$name],
    }

    file {
        "/home/${name}/ee-logs.tar.gz":
            ensure => "present",
            source => "/vagrant/homedir/ee-logs.tar.gz",
            require => User[$name],
    }

    file {
        "/home/${name}/logs":
            ensure => "directory",
            require => User[$name],
    }    

    exec { "untar shit ${name}":
            command => "tar -xzf /home/${name}/ee-logs.tar.gz -C /home/${name}/logs",
            require => File["/home/${name}/logs"],
    }
}


create_users { $users: }

package { "tmux": ensure => "installed" }
package { "mc": ensure => "installed" }
package { "htop": ensure => "installed" }
package { "sl": ensure => "installed" }
