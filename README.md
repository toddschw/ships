#ShipSticks Ruby Challenge

##API Documentation

###These are CRUD sample requests:

CREATE

1. Creates a product

```
curl -i -H "Accept: application/JSON" -H "Content-type: application/JSON" -X POST -d '{"name":"new product","category":"new cat","length":10,"width":20,"height":30,"weight":40}' https://fathomless-shelf-9413.herokuapp.com/api/items
```

READ

1. Shows ALL products
2. Shows ONE product that best matches a given length/width/height/weight query

```
curl -i -H "Accept: application/JSON" -X GET https://fathomless-shelf-9413.herokuapp.com/api/items
```

```
curl -i -H "Accept: application/JSON" -H "Content-type: application/JSON" -X GET -d '{"length":10,"width":20,"height":30,"weight":40}' https://fathomless-shelf-9413.herokuapp.com/api/query
```

UPDATE

1. Updates a product
```
curl -i -H "Accept: application/JSON" -H "Content-type: application/JSON" -X PUT -d '{"length":10,"width":20,"height":30,"weight":50}' https://fathomless-shelf-9413.herokuapp.com/api/items/12
```

DESTROY

1. Deletes a product
```
curl -i -H "Accept: application/JSON" -X DELETE https://fathomless-shelf-9413.herokuapp.com/api/items/12
```

##Script to load products.JSON (as a rake task)

```
task :populatedb => :environment do
    require 'json'

    file = File.read('products.json')
    data_hash = JSON.parse(file)

    data_hash.each do | key, value |
      record_count = value.count
      for i in 0..(record_count - 1)
         item = Item.new value[i]
         item.save
      end
    end
end
```

