#!/bin/sh

pipenv run ansible-playbook -i hosts playbook.yml -b --ask-become-pass -v
