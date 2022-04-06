setup-tools:
	chmod +x setup-tools/install.sh
	setup-tools/./install.sh

banner:
	@printf "\n###\n### Antes de executar o script, por favor inclua os hosts no arquivo inventory/inventory.ini.\n###\n\n";

install-node-exporter: banner
	ansible-playbook -T 120 \
	--extra-vars="exporter_action=install exporter=node_exporter" \
	-i inventory/inventory.ini _install.yml

uninstall-node-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=uninstall exporter=node_exporter" \
	-i inventory/inventory.ini _uninstall.yml

install-redis-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=install exporter=redis_exporter" \
	-i inventory/inventory.ini _install.yml

uninstall-redis-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=uninstall exporter=redis_exporter" \
	-i inventory/inventory.ini _uninstall.yml

install-redis-sentinel-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=install exporter=redis_exporter" \
	-i inventory/inventory.ini _install.yml

uninstall-redis-sentinel-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=uninstall exporter=redis_sentinel_exporter" \
	-i inventory/inventory.ini _uninstall.yml

install-oracledb-exporter: banner
	ansible-playbook -T 120 \
	--extra-vars="exporter_action=install exporter=oracledb_exporter" \
	-i inventory/inventory.ini _install.yml

uninstall-oracledb-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=uninstall exporter=oracledb_exporter" \
	-i inventory/inventory.ini _uninstall.yml

install-nginx-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=install exporter=nginx_exporter" \
	-i inventory/inventory.ini _install.yml

uninstall-nginx-exporter: banner
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=uninstall exporter=nginx_exporter" \
	-i inventory/inventory.ini _uninstall.yml