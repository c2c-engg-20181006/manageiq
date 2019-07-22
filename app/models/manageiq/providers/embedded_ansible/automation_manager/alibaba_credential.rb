class ManageIQ::Providers::EmbeddedAnsible::AutomationManager::AlibabaCredential < ManageIQ::Providers::EmbeddedAnsible::AutomationManager::CloudCredential
  include ManageIQ::Providers::AnsibleTower::Shared::AutomationManager::AlibabaCredential

  def self.display_name(number = 1)
    n_('Credential (Alibaba)', 'Credentials (Alibaba)', number)
  end
end
