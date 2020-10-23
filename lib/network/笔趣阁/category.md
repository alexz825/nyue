[获取所有分类](https://shuapi.jiaston.com/Categories/BookCategory.html)
```
url: https://shuapi.jiaston.com/Categories/BookCategory.html
method: GET

example:
GET https://shuapi.jiaston.com/Categories/BookCategory.html
Response:
{
    "status": 1,
    "info": "success",
    "data": [
        {
            "Id": "1",
            "Name": "玄幻奇幻",
            "Count": 174837
        },
        {
            "Id": "2",
            "Name": "武侠仙侠",
            "Count": 63744
        },
        {
            "Id": "3",
            "Name": "都市言情",
            "Count": 81181
        },
        {
            "Id": "4",
            "Name": "历史军事",
            "Count": 20734
        },
        {
            "Id": "5",
            "Name": "科幻灵异",
            "Count": 52945
        },
        {
            "Id": "6",
            "Name": "网游竞技",
            "Count": 14716
        },
        {
            "Id": "7",
            "Name": "女生频道",
            "Count": 189875
        },
        {
            "Id": "66",
            "Name": "同人小说",
            "Count": 5279
        }
    ]
}
```

## 获取分类下书籍热门信息
排序方式[(热门)hot/(新书)new/(好评)vote/(完结)over]
https://shuapi.jiaston.com/Categories/(上一步获取到的categoryId)/(排序方式)/(page).html
[例子](https://scxs.pysmei.com/Categories/2/hot/1.html)
```json
{
	"status": 1,
	"info": "success",
	"data": {
		"BookList": [{
			"Id": 46439,
			"Name": "求道武侠世界",
			"Author": "大荒散人",
			"Img": "qiudaowuxiashijie.jpg",
			"Desc": "浪迹江湖，道在脚下，这是一个求道者的故事。",
			"CName": "武侠仙侠",
			"Score": 7.5
		}],
        "HasNext": true,
        "Page": 1
    }
}
```