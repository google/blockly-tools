/**
 * @license
 * Visual Blocks Editor
 *
 * Copyright 2018 Google Inc.
 * https://developers.google.com/blockly/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Generates list of issues and PRs for release.
 *
 * Queries the GitHub API for a list of all issues and pull requests
 * that have been closed since the last push to master.
 */
'use strict';

function genBlocklyReleaseNotes(startDate, endDate) {
  genBlocklyIssueNotes(startDate, endDate);
  genBlocklyPrNotes(startDate, endDate);
}

function genBlocklyIssueNotes (startDate, endDate) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      // Result is ready:
      var issuesJson = JSON.parse(xhttp.response);
      var issuesList = '';
      for (var i = 0; i < issuesJson.items.length; i++) {
        var item = issuesJson.items[i];
        var link = '<a href="https://github.com/google/blockly/issues/'
            + item.number + '">#' + item.number + '</a>';
        issuesList += item.title + ' (' + link + ')\n<br>';
      }
      document.getElementById("issues").innerHTML = issuesList;
    }
  };

  var query = 'https://api.github.com/search/issues?q=repo:google/blockly+is:issue+closed:'
      + startDate + '..' + endDate;
  xhttp.open("GET", query, true);
  xhttp.send();
}

function genBlocklyPrNotes (startDate, endDate) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      // Result is ready:
      var prJson = JSON.parse(xhttp.response);
      var prList = '';
      for (var i = 0; i < prJson.items.length; i++) {
        var item = prJson.items[i];
        var link = '<a href="https://github.com/google/blockly/pull/'
            + item.number + '">#' + item.number + '</a>';
        prList += item.title + ' (' + link + ')\n<br>';
      }
      document.getElementById("pull-requests").innerHTML = prList;
    }
  };

  var query = 'https://api.github.com/search/issues?q=repo:google/blockly+is:pr+closed:'
      + startDate + '..' + endDate;
  xhttp.open("GET", query, true);
  xhttp.send();
}

function getLastMergeDate() {
  var MONTH_IN_MS = 2592000000;

  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      // Result is ready:
      var pulls = JSON.parse(xhttp.response);
      var lastDate = pulls.items[0].closed_at.split('T')[0];
      document.getElementById("startDate").value = lastDate;
    }
  };
  var date = new Date();
  var endDate = date.toISOString().split('T')[0];
  date.setTime(date.getTime() - 3 * MONTH_IN_MS);
  var startDate = date.toISOString().split('T')[0];
  var query = 'https://api.github.com/search/issues?q=repo:google/blockly+is:pr+base:master+closed:'
      + startDate + '..' + endDate;
  xhttp.open("GET", query, true);
  xhttp.send();
}
