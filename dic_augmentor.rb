require "fileutils"

class DicAugmentor
  LOCAL_DICT_PATH = "~/Library/Spelling/LocalDictionary"

  def initialize(word_file)
    @dict_path = LOCAL_DICT_PATH
    
    begin
      @word_file = File.open word_file
    rescue Errno::ENOENT => e
      puts "[#{self.class}] could not find new dictionary file at #{word_file}"
      exit 1
    end

    begin
      @local_dict = File.open @dict_path
    rescue Errno::ENOENT => e
      puts "[#{self.class}] could not find local dictionary file at #{@dict_path}"
      exit 2
    end
  end

  def augment
    backup_local_dict
    merge_new_dict
    alphabetize_merged_dict
    write_merged_dict_to_local_dict
  end

  private

  def backup_local_dict
    FileUtils.cp @dict_path, "#{@dict_path}.backup"
  end

  def merge_new_dict
    
  end

  def alphabetize_merged_dict
    
  end

  def write_merged_dict_to_local_dict
    
  end
end