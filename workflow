name: pep8_checker
on:
  push:
    paths:
    - '**.k'
  status: {}
jobs:
  pep8_checker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: '3.8'
      - name: Display the path and python`s version 
        run: |
          import os
          import sys
          print(sys.version)
          print(os.environ['PATH'])
        shell: python
      - name: Python Style Checker
        run: |
          python -m pip install --upgrade pip
          pip install flake8 numpy matplotlib
      - run: python ./project2/project.py $(find ./project2 -name "*.k")
      - name: Deploy report page
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./project2
          user_name: 'github-actions[bot]'
          user_email: 'github-actions[bot]@users.noreply.github.com'
