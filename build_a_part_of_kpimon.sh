#sudo systemctl status nginx
#sudo nginx -t
sudo cp oaic/ric-scp-kpimon/scp-kpimon-config-file.json /var/www/xApp_config.local/config_files/scp-kpimon-config-file.json
sudo systemctl reload nginx
export MACHINE_IP=`hostname  -I | cut -f1 -d' '`
curl http://${MACHINE_IP}:5010/config_files/scp-kpimon-config-file.json
cd oaic/ric-scp-kpimon
sudo docker build . -t xApp-registry.local:5008/scp-kpimon:1.0.1

export KONG_PROXY=`sudo kubectl get svc -n ricplt -l app.kubernetes.io/name=kong -o jsonpath='{.items[0].spec.clusterIP}'`
export APPMGR_HTTP=`sudo kubectl get svc -n ricplt --field-selector metadata.name=service-ricplt-appmgr-http -o jsonpath='{.items[0].spec.clusterIP}'`
export ONBOARDER_HTTP=`sudo kubectl get svc -n ricplt --field-selector metadata.name=service-ricplt-xapp-onboarder-http -o jsonpath='{.items[0].spec.clusterIP}'`
curl --location --request GET "http://$KONG_PROXY:32080/onboard/api/v1/charts"