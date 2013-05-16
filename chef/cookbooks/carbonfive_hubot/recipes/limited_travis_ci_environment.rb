include_recipe "build-essential"
include_recipe "networking_basic"
include_recipe "sysctl"

include_recipe "libqt4"
include_recipe "nodejs::multi"
include_recipe "xserver"

include_recipe "redis"
include_recipe "python"

package "libicu48"
