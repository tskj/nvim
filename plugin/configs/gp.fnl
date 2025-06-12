(local {: run} (require :user.utils))

(-> :gp
    (require)
    (. :setup)
    (run {:providers {:openai {:disable true}
                      :googleai {:disable false}}
          :agents [{:provider "googleai"
                    :name "CodeGemini"
                    :command true
                    :model {:model "gemini-2.0-flash" :temperature 0.8 :top_p 1}
                    :system_prompt (.. 
                                     "You are an AI working as a code editor.\n\n"
                                     "Only reply with code, no other text.\n\n"
                                     "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                                     "END YOUR ANSWER WITH:\n\n")}
                   {:provider "googleai"
                    :name "ChatGemini"
                    :chat true
                    :model {:model "gemini-2.0-flash" :temperature 0.8 :top_p 1}
                    :system_prompt "You are a helpful AI assistant."}]}))

