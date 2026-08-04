window.SIMPLECOV_DATA = {
  "$schema": "https://raw.githubusercontent.com/simplecov-ruby/simplecov/main/schemas/coverage-v1.0.schema.json",
  "meta": {
    "schema_version": "1.0",
    "simplecov_version": "1.0.3",
    "command_name": "RSpec",
    "project_name": "Pkp-user-management",
    "timestamp": "2026-08-04T21:24:28.626+07:00",
    "root": "/home/tax015/projects/pkp-user-management",
    "commit": "3bddd260eede917c125e58ea08570a8a780ccb7f",
    "primary_coverage": "line",
    "line_coverage": true,
    "branch_coverage": false,
    "method_coverage": false
  },
  "total": {
    "lines": {
      "covered": 0,
      "missed": 7,
      "omitted": 12,
      "total": 7,
      "percent": 0.0,
      "strength": 0.0
    }
  },
  "coverage": {
    "app/controllers/application_controller.rb": {
      "source": [
        "class ApplicationController < ActionController::Base",
        "  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.",
        "  allow_browser versions: :modern",
        "",
        "  # Changes to the importmap will invalidate the etag for HTML responses",
        "  stale_when_importmap_changes",
        "end"
      ],
      "lines": [
        0,
        null,
        0,
        null,
        null,
        0,
        null
      ],
      "lines_covered_percent": 0.0,
      "covered_lines": 0,
      "missed_lines": 3,
      "omitted_lines": 4,
      "total_lines": 3
    },
    "app/helpers/application_helper.rb": {
      "source": [
        "module ApplicationHelper",
        "end"
      ],
      "lines": [
        0,
        null
      ],
      "lines_covered_percent": 0.0,
      "covered_lines": 0,
      "missed_lines": 1,
      "omitted_lines": 1,
      "total_lines": 1
    },
    "app/jobs/application_job.rb": {
      "source": [
        "class ApplicationJob < ActiveJob::Base",
        "  # Automatically retry jobs that encountered a deadlock",
        "  # retry_on ActiveRecord::Deadlocked",
        "",
        "  # Most jobs are safe to ignore if the underlying records are no longer available",
        "  # discard_on ActiveJob::DeserializationError",
        "end"
      ],
      "lines": [
        0,
        null,
        null,
        null,
        null,
        null,
        null
      ],
      "lines_covered_percent": 0.0,
      "covered_lines": 0,
      "missed_lines": 1,
      "omitted_lines": 6,
      "total_lines": 1
    },
    "app/models/application_record.rb": {
      "source": [
        "class ApplicationRecord < ActiveRecord::Base",
        "  primary_abstract_class",
        "end"
      ],
      "lines": [
        0,
        0,
        null
      ],
      "lines_covered_percent": 0.0,
      "covered_lines": 0,
      "missed_lines": 2,
      "omitted_lines": 1,
      "total_lines": 2
    }
  },
  "groups": {
    "Controllers": {
      "lines": {
        "covered": 0,
        "missed": 3,
        "omitted": 4,
        "total": 3,
        "percent": 0.0,
        "strength": 0.0
      },
      "files": [
        "app/controllers/application_controller.rb"
      ]
    },
    "Channels": {
      "lines": {
        "covered": 0,
        "missed": 0,
        "omitted": 0,
        "total": 0,
        "percent": 100.0,
        "strength": 0.0
      },
      "files": []
    },
    "Models": {
      "lines": {
        "covered": 0,
        "missed": 2,
        "omitted": 1,
        "total": 2,
        "percent": 0.0,
        "strength": 0.0
      },
      "files": [
        "app/models/application_record.rb"
      ]
    },
    "Mailers": {
      "lines": {
        "covered": 0,
        "missed": 0,
        "omitted": 0,
        "total": 0,
        "percent": 100.0,
        "strength": 0.0
      },
      "files": []
    },
    "Helpers": {
      "lines": {
        "covered": 0,
        "missed": 1,
        "omitted": 1,
        "total": 1,
        "percent": 0.0,
        "strength": 0.0
      },
      "files": [
        "app/helpers/application_helper.rb"
      ]
    },
    "Jobs": {
      "lines": {
        "covered": 0,
        "missed": 1,
        "omitted": 6,
        "total": 1,
        "percent": 0.0,
        "strength": 0.0
      },
      "files": [
        "app/jobs/application_job.rb"
      ]
    },
    "Libraries": {
      "lines": {
        "covered": 0,
        "missed": 0,
        "omitted": 0,
        "total": 0,
        "percent": 100.0,
        "strength": 0.0
      },
      "files": []
    }
  },
  "errors": {}
};
