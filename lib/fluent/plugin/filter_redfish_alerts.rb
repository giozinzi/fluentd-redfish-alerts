#
# Copyright 2021 - Giovanni Zinzi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/filter"

module Fluent
  module Plugin
    class RedfishAlertsFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter("redfish_alerts", self)
      
      # config_param works like other plugins

      def configure(conf)
        super
        # No config needed rn
      end

      # def start
      #   super
      #   # Override this method if anything needed as startup.
      # end

      # def shutdown
      #   # Override this method to use it to free up resources, etc.
      #   super
      # end

      def alertFilter(record, time)
        record.each do |key, val|
          # Handling CPU Alerts. GET https://172.16.0.14/redfish/v1/TelemetryService/Triggers/CPUCriticalTrigger + https://172.16.0.14/redfish/v1/TelemetryService/Triggers/TMPCpuCriticalTrigger (starts after CPU0703)
          if (val == "CPU0000" || val == "CPU0003" || val == "CPU0004" || val == "CPU0006" || val == "CPU0700" || val == "CPU0701" || val == "CPU0702" || val == "CPU0703" || val == "TMP0204" || val == "TMP0201" || val == "TMP0203")
            tag = "mdm"
            myRecord = {}
            myRecord["Namespace"] = "ColomanagerFluentdRedfish"
            myRecord["Metric"] = "CPUAlert"
            myRecord["Dimensions"] = {"Region" => "CentralusEUAP", "IP" => record["ip"], "Id" => "#{val}", "Message" => record['Message']}
            myRecord["Value"] = "1"
            router.emit(tag, time, myRecord)
          end
          # Handling MEM Alerts. GET https://172.16.0.14/redfish/v1/TelemetryService/Triggers/MEMCriticalTrigger
          if (val == "MEM0003" || val == "MEM0010" || val == "MEM0702" || val == "MEM0002")
            tag = "mdm"
            myRecord = {}
            myRecord["Namespace"] = "ColomanagerFluentdRedfish"
            myRecord["Metric"] = "MEMAlert"
            myRecord["Dimensions"] = {"Region" => "CentralusEUAP", "IP" => record["ip"], "Id" => "#{val}", "Message" => record['Message']}
            myRecord["Value"] = "1"
            router.emit(tag, time, myRecord)
          end
          # Handling NVMe Alerts. GET https://172.16.0.14/redfish/v1/TelemetryService/Triggers/NVMeCriticalTrigger
          if (val == "PDR117")
            tag = "mdm"
            myRecord = {}
            myRecord["Namespace"] = "ColomanagerFluentdRedfish"
            myRecord["Metric"] = "NVMeAlert"
            myRecord["Dimensions"] = {"Region" => "CentralusEUAP", "IP" => record["ip"], "Id" => "#{val}", "Message" => record['Message']}
            myRecord["Value"] = "1"
            router.emit(tag, time, myRecord)
          end
          # Handling PDR (physical disk) Alerts. GET https://172.16.0.14/redfish/v1/TelemetryService/Triggers/PDRCriticalTrigger
          if (val == "PDR64" || val == "PDR44" || val == "PDR63" || val == "PDR62" || val == "PDR46" || val == "PDR61" || val == "PDR57" || val == "PDR47" || val == "PDR73" || val == "TMP0127" || val == "TMP0125" || val == "TMP0128")
            tag = "mdm"
            myRecord = {}
            myRecord["Namespace"] = "ColomanagerFluentdRedfish"
            myRecord["Metric"] = "DiskAlert"
            myRecord["Dimensions"] = {"Region" => "CentralusEUAP", "IP" => record["ip"], "Id" => "#{val}", "Message" => record['Message']}
            myRecord["Value"] = "1"
            router.emit(tag, time, myRecord)
          end
        end
      end

      def filter(tag, time, record)
        alertFilter(record, time)
      end
    end
  end
end
