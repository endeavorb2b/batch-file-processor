# Batch Process Large Files With Multithreading
Takes a script and file as input and loops over it.

#### Getting Started
    docker-compose build
    docker-compose run app bash
    
#### Run example
Setup .env by copying the .env.sample. Once that is setup change SPLIT to 2 and execute the example below.

    ./run.sh test.sh files/test
    
#### Creating Scripts
You can create your own script and add it into the scripts folder.
