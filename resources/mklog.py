"""
Create JSON log structure for Amazon CloudWatch.

# USAGE

# Import modules.
import json
from mklog import WriteLog

# Initiate with empty dictionary.
logger = WriteLog({})

# Collect entries to log.
logger.log('<strkey>', '<value>')
logger.log('<intkey>', <value>)
logger.log('<boolkey>', <True/False>)

# Print out to CloudWatch as accumulated log.
print(json.dumps(logger.text))
"""


class WriteLog(object):
    """Create log object."""

    def __init__(self, text):
        """Initialize log content."""
        self.text = text

    def log(self, key, value):
        """Update log content."""
        self.text[key] = value
