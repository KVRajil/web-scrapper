# web-scrapper
Ruby command line program that can fetch web pages and saves them to disk for later retrieval and browsing
This script will clone the html file, images, stylesheets and javascripts

How to run:

Steps
 1. Build docker 
       
        docker build -t web-scrapper .
 2. Use fetch.sh to run the docker and ruby script

        ./fetch.sh https://www.google.com/
        ./fetch.sh https://www.google.com https://rubyonrails.org/
        ./fetch.sh --meta https://www.google.com https://rubyonrails.org/

