name              "carbonfive_hubot"
maintainer        "Carbon Five"
maintainer_email  "pair+doc+jason@carbonfive.com"
license           "MIT"
description       "Sets up Hubot"
version           "0.1.0"

recipe "carbonfive_hubot::default", "Install Hubot"

supports "ubuntu", "12.04"

depends "build-essential"
depends "networking_basic"
depends "sysctl"
depends "libqt4"
depends "nodejs::multi"
depends "xserver"
depends "redis"
depends "python"
