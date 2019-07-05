# REdash Helm Chart

* Installs the [Redash](https://redash.io/)

## TL;DR;

```console
$ helm install stable/redash-helm
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/redash-helm
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

### Notes
- create the database before deployment.
- set `dbCreateTables`:`true` if database tables are not exists or set `false`.
- make sure `postgresql` and `externalPostgres` both are not enabled. only one should be enabled.
