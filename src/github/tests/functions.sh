#!/bin/sh

get_port () {
  case $1 in
    lucee5)
      echo -n "60005"
      ;;
    adobe2016)
      echo -n "62016"
      ;;
    adobe2018)
      echo -n "62018"
      ;;
    mysql56)
      echo -n "3306"
      ;;
    postgres)
      echo -n "5432"
      ;;
    sqlserver)
      echo -n "1433"
      ;;
    *)
      echo -n "unknown"
      ;;
  esac
}

get_db () {
  case $1 in
    mysql56)
      echo -n "mysql"
      ;;
    *)
      echo -n "${1}"
      ;;
  esac
}
