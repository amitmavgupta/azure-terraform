# IP Address Management (IPAM) with Azure CNI Powered by Cilium
Azure CNI Powered by Cilium can be deployed using two different methods for assigning pod IPs:
- Assign IP addresses from a virtual network (similar to existing Azure CNI with Dynamic Pod IP Assignment)
- Assign IP addresses from an overlay network (similar to Azure CNI Overlay mode)

# Ensure you have enough quota
Go to the Subscription blade, navigate to "Usage + Quotas", and make sure you have enough quota for the following resources:

- Regional vCPUs
- Standard Dv4 Family vCPUs
