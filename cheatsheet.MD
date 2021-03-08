# Cheat Sheet for K8S

## Labels

  ```sh
  # Add label to resources
  kubectl label <resource> <key>=<value>
  ```

  ```sh
  # Example: Adding label to node
  kubectl label node1 isProd=false
  ```

  ```sh
  # Overwriting label
  kubectl label node1 isProd=false --overwrite
  ```
  
  ```sh
  # Removing a label
  #
  # The [-] sign will delete the label
  #
  kubectl label node1 isProd- 
  ```
  
### List of all resources 
```sh
kubectl api-resources --verbs=list --namespaced  -o name \
        | xargs -n 1 kubectl get -A --ignore-not-found --show-kind 
```

### Sort events by date
```
kubectl get events --sort-by='.metadata.creationTimestamp' -A
```
