FROM ucbbar/chisel-bootcamp:latest

RUN cp -r /coursier_cache /home/bootcamp/coursier_cache
ENV COURSIER_CACHE=/home/bootcamp/coursier_cache

USER bootcamp
WORKDIR /chisel-bootcamp

EXPOSE 8888
CMD jupyter notebook --no-browser --ip 0.0.0.0 --port 8888