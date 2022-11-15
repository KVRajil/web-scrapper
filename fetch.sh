docker build -t web-scrapper .
docker run -v $(pwd):/project -it --rm web-scrapper "$@"
