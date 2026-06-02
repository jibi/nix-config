def notify_send(*args) = system(ENV.fetch("NOTIFY_SEND"), "-u", "critical", *args)

warned_file = File.join(ENV.fetch("XDG_RUNTIME_DIR"), "battery-watch-warned")
sys_bat = "/sys/class/power_supply/BAT0"

if File.read(File.join(sys_bat, "/status")).strip != "Discharging"
  File.unlink(warned_file) if File.exist?(warned_file)
  exit
end

cap = File.read(File.join(sys_bat, "/capacity")).to_i
if cap <= 3
  notify_send "Battery drained", "suspending."
  sleep 2
  system(ENV.fetch("SYSTEMCTL"), "suspend")
elsif cap <= 10 && !File.exist?(warned_file)
  notify_send "Battery low", "#{cap}%"
  File.write(warned_file, "")
end
