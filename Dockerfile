FROM ubuntu:latest
LABEL Name=tinnyterrgithub
RUN apt -y update && apt install -y python3 && apt install -y python3-pip
RUN pip install mkdocs-material mkdocs-material[imaging] pymdown-extensions
CMD ["mkdocs new .", "mkdocs serve"]
