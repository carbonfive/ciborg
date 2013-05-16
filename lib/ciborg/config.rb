# encoding: UTF-8
require "hashie"

module Ciborg
  class Config < Hashie::Dash
    property :path
    property :aws_key
    property :aws_secret
    property :instance_id
    property :master

    property :instance_size, :default => 'c1.medium'
    property :ssh_port, :default => 22
    property :server_ssh_key, :default => Proc.new { default_ssh_key }
    property :github_ssh_key, :default => Proc.new { default_ssh_key }
    property :recipes, :default => ["carbonfive_hubot::limited_travis_ci_environment", "carbonfive_hubot"]
    property :cookbook_paths, :default => ['./chef/cookbooks/', './chef/travis-cookbooks/ci_environment']
    property :node_attributes, :default => Proc.new { default_node_attributes }
    property :security_group, :default => 'ciborg'
    property :availability_zone, :default => "us-east-1b"

    def initialize(attributes = {})
      super
      self["node_attributes"] = Hashie::Mash.new(node_attributes)
    end

    def github_ssh_key_path
      File.expand_path(self["github_ssh_key"]) if self["github_ssh_key"]
    end

    def github_ssh_pubkey_path
      github_ssh_key_path + ".pub" if self["github_ssh_key"]
    end

    def github_ssh_key
      File.read(github_ssh_key_path)
    end

    def github_ssh_pubkey
      File.read(github_ssh_pubkey_path)
    end

    def server_ssh_key_path
      File.expand_path(self["server_ssh_key"]) if self["server_ssh_key"]
    end

    def server_ssh_pubkey_path
      server_ssh_key_path + ".pub" if self["server_ssh_key"]
    end

    def server_ssh_key
      File.read(server_ssh_key_path)
    end

    def server_ssh_pubkey
      File.read(server_ssh_pubkey_path)
    end

    def master_url
      "https://#{master}" if master
    end

    def node_attributes=(attributes)
      self["node_attributes"] = Hashie::Mash.new(attributes)
    end

    def valid?
      errors.empty?
    end

    def errors
      []
    end

    def soloistrc
      {
        "recipes" => recipes,
        "cookbook_paths" => cookbook_paths,
        "node_attributes" => node_attributes.to_hash
      }
    end

    def save
      return self unless path
      File.open(path, "w+") { |file| file.write(YAML.dump(JSON.parse(JSON.dump(to_hash)))) }
      self
    end

    def update(options = {})
      options.each_pair do |attr, value|
        self.send("#{attr}=", value)
      end
      save
    end

    def reload
      self.class.from_file(path)
    end

    def to_hash
      hash = super
      hash.delete("path")
      {
        "ssh_port" => ssh_port,
        "master" => master,
        "server_ssh_key" => server_ssh_key_path,
        "recipes" => recipes,
        "cookbook_paths" => cookbook_paths,
        "node_attributes" => node_attributes
      }.merge(hash)
    end

    def display
      <<OOTPÜT.gsub(/(\S)\s+$/, '\1').gsub(/^\./, '')
-- ciborg configuration --
  Instance ID:        #{instance_id}
  IP Address:         #{master}
  Instance size:      #{instance_size}
OOTPÜT
    end

    def self.from_file(yaml_file)
      config = {:path => yaml_file}
      config.merge!(read_config(yaml_file)) if File.exists?(yaml_file)
      config.delete('keypair_name')
      self.new(config)
    end

    def self.read_config(yaml_file)
      File.open(yaml_file, "r") { |file| YAML.load(file.read) }
    end

    private

    def self.default_ssh_key
      "~/.ssh/id_rsa" if File.exists?(File.expand_path("~/.ssh/id_rsa"))
    end

    def self.default_node_attributes
      {
        :travis_build_environment => {
          :user => "hubot",
          :group => "nogroup",
          :home => "/home/hubot"
        }
      }
    end
  end
end
