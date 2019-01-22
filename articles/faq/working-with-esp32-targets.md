# Working with ESP32 targets

## Is the ESP32 Dev Kit C the ONLY board version that will work with nanoFramework?

There are available several different versions including: ESP32-WROOM-32, ESP32-WROOM-32D, ESP32-WROOM-32U, ESP32-SOLO-1, ESP32-WROVER-B, ESP32-WROVER-IB, etc.
The current ESP32 Dev Kit C image that we provide works on all ESP32 boards that use the ESP32-Wroom-32x or ESP32-WROVER modules. The ESP32-WROVER modules also have PSRAM which we currently don't support but will in the future.  The SOLO modules have only one core which currently won't work as we start the nanoCLR on the 2nd core.

## Can I use Smart Config to configure my ESP32 devices?

Yes you can! The Smart Config is automatically started when the device is booted and there is no wireless SSID set up. i.e. When the device is first flashed.

To configure the device use one of the Smart Config apps on your phone such as :- the ESP8266 SmartConfig, DHC smartConfig apps on Android and EspressiF ESpTouch on IOS.

Connect phone to Wifi to the Access point, run Smart Config application which will prompt you for the AP password.
This will then send the details to the device. The device saves the details and connects to the AP point. When connected it confirms the connection back to the Phone.

When the device is next rebooted the device automatically connects to AP as the WiFi details have been saved.

For more information see [here](https://www.switchdoc.com/2018/06/tutorial-esp32-bc24-provisioning-for-wifi).

In your application you can wait for the network to be configured/connected by waiting for the IP to be set.

```csharp
static void WaitIP()
{
    Console.WriteLine("Wait for IP");
        while (true)
        {
            NetworkInterface ni = NetworkInterface.GetAllNetworkInterfaces()[0];
            if (ni.IPv4Address != null && ni.IPv4Address.Length > 0)
            {
                if (ni.IPv4Address[0] != '0')
                {
                    Console.WriteLine("Have IP " + ni.IPv4Address);
                    break;
                }
            }
            Thread.Sleep(1000);
        }
}
```
