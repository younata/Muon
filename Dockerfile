FROM swift:latest

add . /code

WORKDIR /code

CMD ["swift", "test"]
