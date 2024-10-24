#!/bin/sh
CONTROLLER_PATH="/usr/lib/lua/luci/controller/mcu.lua"
VIEW_PATH="/usr/lib/lua/luci/view/mcu/index.htm"

mkdir -p /usr/lib/lua/luci/controller
mkdir -p /usr/lib/lua/luci/view/mcu

cat << 'EOF' > "$CONTROLLER_PATH"
module("luci.controller.mcu", package.seeall)

function index()
    entry({"admin", "mcu"}, template("mcu/index"), _("MCU Control"), 60).dependent = true
    entry({"admin", "mcu", "poweroff"}, call("action_poweroff"), _("Power Off"), 61)
end

function action_poweroff()
    local result = os.execute("ubus call mcu cmd_json '{\"poweroff\":\"1\"}'")
    luci.http.redirect(luci.dispatcher.build_url("admin/mcu"))
end
EOF

cat << 'EOF' > "$VIEW_PATH"
<h2>MCU Control</h2>
<form action="{{url('admin/mcu/poweroff')}}" method="post">
    <input type="submit" value="Power Off" />
</form>
EOF

echo "Button installed successfully."
