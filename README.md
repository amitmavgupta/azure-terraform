# What is the main purpose of the repo?
This repo will discuss how to deploy Cilium on AKS clusters using the following CNI's:
* Isovalent Enterprise for Cilium in Azure Marketplace.
* Isovalent Enterprise for Cilium in Azure Marketplace (Azure Linux as the host OS).
* Azure CNI powered by Cilium (Overlay Mode) with Cilium as the Network Policy
* Azure CNI powered by Cilium (Dynamic IP allocation) with Cilium as the Network Policy
* Azure CNI powered by Cilium (Overlay Mode) with Azure Linux as the host OS
* Azure CNI powered by Cilium (Dynamic IP allocation) with Azure Linux as the host OS
* Nodepools in Different Availability Zones (with Azure CNI powered by Cilium as the choice of CNI)

You will also get to learn how to deploy an AKS cluster using the other AKS CNI's like:
* Kubenet in IPv4 and Dual Stock mode
* Bring your own CNI (BYOCNI)
* Bring your own CNI (BYOCNI) with Azure Linux as the host OS
* Azure CNI Overlay in IPv4
* Azure CNI with Azure NPM as the network policy 
* Azure CNI with Calico as the network policy

# Ensure you have enough quota
Go to the Subscription blade, navigate to "Usage + Quotas", and make sure you have enough quota for the following resources:

- Regional vCPUs
- Standard Dv4 Family vCPUs