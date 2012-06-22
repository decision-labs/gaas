Gaas
========================

# API Doc

# Introduction to GaaS

GaaS is GPU as a Service running on Amazon EC2 GPU instances.
See presentation at:

## Vector Add


```shell
$ curl -X POST \
  -H 'Accept: application/vnd.gaas.v1' \
  -H 'Content-Type: application/json' \
  -d '{ "data": { "v1":[23.12,2.23,30], "v2": [3.232,2.23,1.334] } }' \
  https://gaas-server.com/api/vector_add
```

On Success: 201 Created

```javascript
{
  "result":[
    26.352001190185547,
    4.460000038146973,
    31.333999633789062
  ]
}
```

# dev server:

http://192.168.0.123:3000/api/vector_add


________________________

License
