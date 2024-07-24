
#!/bin/bash
# این یک فایل .sh است که یک حلقه تعریف می کند
echo "لطفا یک عدد وارد کنید به اسم start"
read start # مقدار ورودی را در متغیر start ذخیره می کند
echo "لطفا یک عدد دیگر وارد کنید به اسم end"
read end # مقدار ورودی را در متغیر end ذخیره می کند
echo "لطفا یک عدد دیگر وارد کنید به اسم port"
read port # مقدار ورودی را در متغیر port ذخیره می کند
echo "شما وارد کرده اید:"
echo "start = $start"
echo "end = $end"
echo "port = $port"
# این یک حلقه for است که از start شروع می کند و تا end ادامه می دهد
for ((xxx = start; xxx <= end; xxx++))
do
  let sss=port+xxx-start # این خط یک متغیر جدید به اسم sss می سازد که از جمع port و xxx و کم کردن start حاصل می شود
  echo "install number = $xxx"
  echo "panel port = $sss" # این خط مقدار sss را با عنوان panel port نمایش می دهد
  # این قسمت کدی است که شما فرستاده اید و من درون حلقه قرار داده ام
  # من فرض کرده ام که متغیرهای xxx و sss در این کد مورد استفاده قرار می گیرند
  # اگر این فرض اشتباه است، لطفا به من بگویید تا اصلاح کنم
  mkdir -p /app/env$xxx
  echo "/app/3x-ui-$xxx/bin" > /app/env$xxx/XUI_BIN_FOLDER
  echo "/app/3x-ui-$xxx/log" > /app/env$xxx/XUI_LOG_FOLDER
  echo "/app/3x-ui-$xxx/db" > /app/env$xxx/XUI_DB_FOLDER
  cd /app
  tar zxvf x-ui-linux-amd64.tar.gz
  mv /app/x-ui /app/3x-ui-$xxx
  mkdir -p /app/3x-ui-$xxx/db
  mkdir -p /app/3x-ui-$xxx/log
  chmod +x /app/3x-ui-$xxx/x-ui
  chmod +x /app/3x-ui-$xxx/bin/xray-linux-amd64
  envdir /app/env$xxx /app/3x-ui-$xxx/x-ui setting -port $sss
  echo "[Unit]
Description=a$xxx-ui Service
After=network.target
Wants=network.target

[Service]
Environment="XRAY_VMESS_AEAD_FORCED=false"
Type=simple
WorkingDirectory=/app/3x-ui-$xxx/
ExecStart=envdir /app/env$xxx /app/3x-ui-$xxx/x-ui
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/3x-ui-$xxx.service
  systemctl start 3x-ui-$xxx
  systemctl enable 3x-ui-$xxx
done
abc.sh
Displaying abc.sh.
