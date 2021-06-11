#!/bin/sh

pipenv run ansible-playbook -i chroots.example playbook-chroot.yml -v
