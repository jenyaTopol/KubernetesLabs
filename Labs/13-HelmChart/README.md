![](../../resources/k8s-logos.png)

# K8S Hands-on
![Visitor Badge](https://visitor-badge.laobi.icu/badge?page_id=nirgeier)

---

# Helm Chart 

- In This tutorial you will learn the basics of Helm Charts (verison 3).
- This demo will cover the following:
    -   build
    -   package
    -   install
    -   list packages

---

## PreRequirements
- [Helm](https://helm.sh/docs/intro/install/)
- K8S cluster

---

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/nirgeier/KubernetesLabs)
### **<kbd>CTRL</kbd> + click to open in new window**   

---
## `codewizard-helm-demo`

- The custom `codewizard-helm-demo` Helm chart is build upon the following K8S resources:
    -   ConfigMap
    -   Deployment
    -   Service

- Since we are using Helm we also have the following Helm resources:
    -   Chart.yaml
    -   values.yaml
    -   templates/_helpers.tpl

---

### Step 1 - Pack
Pack the ```codewizard-helm-demo``` chart

## `helm package`
> Package a chart directory into a chart archive. 
>  
> `helm package` packages a chart into a **versioned chart archive file**. 
>
> If a path is given, this will look at that path for a chart (which must contain a `Chart.yaml` file) and then package that directory.
```
helm package codewizard-helm-demo
```

### Step 2 - install
- Once the helm is packed we will be able to install it
```sh
# install the package on our cluster
helm install charts-demo codewizard-helm-demo-0.1.0.tgz
```

### step 03: Verify the installation
```sh
# Verify that the chart installed
helm ls

# Check teh resources
kubectl get all
```

### step 04: Test the "server"
- For our test we will be using 3rd container which will execute a wget command to check the response.
- The reply message is from the ```values.yaml```
```sh
# Test the "server"
kubectl run \
        --rm -it \
        --restart=Never \
        --image=busybox bbox1 \
        -- sh -c "wget -qO- http://charts-demo-codewizard-helm-demo"
```

# STEP 5:
Perform a Helm upgrade on the ```charts-demo``` release

```
helm upgrade charts-demo codewizard-helm-demo-0.1.0.tgz \
--set nginx.conf.message="Helm Rocks"
```

# STEP 6:
Perform another HTTP GET request. Confirm that the response now has the updated message ```Helm Rocks```

```
kubectl run --image=busybox bbox1 --rm -it --restart=Never \
-- /bin/sh -c "wget -qO- http://charts-demo-codewizard-helm-demo"
```

# STEP 7:
Examine the ```charts-demo``` release history

```
helm history charts-demo
```

# STEP 8:
Rollback the ```charts-demo``` release to previous version

```
helm rollback charts-demo
```

# STEP 9:
Perform another HTTP GET request. Confirm that the response has now been reset to the ```CloudAcademy DevOps 2020 v1``` message stored in the ```values.yaml``` file

```
kubectl run --image=busybox bbox1 --rm -it --restart=Never \
-- /bin/sh -c "wget -qO- http://charts-demo-codewizard-helm-demo"
```

# STEP 10:
Uninstall the ```charts-demo``` release

```
helm uninstall charts-demo
```
<!-- navigation start -->

---

<div align="center">    <img src="../../resources/prev.png">&nbsp;
    <a href="../12-Wordpress-MySQL-PVC">12-Wordpress-MySQL-PVC</a>
    &nbsp;&nbsp;||&nbsp;&nbsp;
    <a href="../14-Logging">14-Logging</a>
    &nbsp;<img src="../../resources/next.png">
</div>

---

<div align="center">
    <small>&copy;CodeWizard LTD</small>
</div>

![Visitor Badge](https://visitor-badge.laobi.icu/badge?page_id=nirgeier)

<!-- navigation end -->