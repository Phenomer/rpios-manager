#!/bin/sh

pipenv run ansible-playbook -i hosts playbook.yml -b --ask-pass --ask-become-pass -v
