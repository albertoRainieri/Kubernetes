FROM        bash:latest
LABEL       maintainer="Mariani alberto <mariani.alberto@libero.it>"

RUN mkdir -p /etc/snmp_notifier
COPY snmp_notifier  /bin/snmp_notifier
COPY description-template.tpl  /etc/snmp_notifier/description-template.tpl
COPY pause.sh /bin/pause.sh

EXPOSE      9464
CMD ["/bin/pause.sh",""]

