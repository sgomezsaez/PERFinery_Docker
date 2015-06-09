#### PERFinery MediaWiki Test Case Sample ####

# Author: Kushal Ganguly <kushalrajaganguly@gmail.com>

1. Open the winery using the web url, for example: http://localhost:8080/winery/

2. Upload the 'MediaWiki.csar' service template file by selecting 'Import CSAR' button of the winery web-page.
The uploaded service template is located under the 'servicetemplates' subdirectory of the repository path directory defined in the 'winery.properties' file. 

3. Copy the 'policytemplates', 'policytypes', 'workload' and 'csv' folders to the repository path folder directory.

Note:
In the performance specification test case example, the performance requirements are specified to the performance policy template 
'PerformancePolicyTemplate' which is specific to the performance policy type 'PerformancePolicyType'.
The performance policy type file is located under the directory: '\policytypes\http%3A%2F%2Fexample.com%2FPolicyTypes\PerformancePolicyType'.
The performance policy template file is located under the directory: '\policytemplates\http%3A%2F%2Fwww.example.org%2FPolicyTemplates\PerformancePolicyTemplate'.

The performance policy type namespace 'http%3A%2F%2Fexample.com%2FPolicyTypes' is common for all performance policy types.
Similarly the performance policy template namespace 'http%3A%2F%2Fwww.example.org%2FPolicyTemplates' is common for all performance policy templates.
They can be manually changed from the 'winery.properties' file. The repository path can also be changed from the properties file.

Each service template contains only a single workload specification XML file. Multiple workload samples are added to the single workload specification file.

In the workload specification test case example, 'MediaWikiWorkload' XML file correspond to 'MediaWiki' service template 
under the directory: 'workload'. The 'MediaWikiWorkload' contains workload sample 'sample1' .

For the 'MediaWiki' service template, the uploaded probabilistic behavior model csv files 'BehaviorModel1.csv' and 'BehaviorModel2.csv' are located 
under the directory: 'csv\MediaWiki\sample1'.
