# This a simple fix so that Python does not write to .python_history.
# https://www.eseth.org/2008/pimping-pythonrc.html
import readline
readline.write_history_file = lambda *args: None
